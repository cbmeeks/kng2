
lock_routines:
	jmp lock_create
	jmp lock_update
	jmp lock_dead
	jmp lock_draw

lock_create:

	lda #30
	sta scroll_time_to_stop

	lda #COLLISION_WITH_MAIN + COLLISION_WITH_MAINBULLET
	sta _objectarray_collisionType, x

	lda #20
	sta _objectarray_hits, x

	lda #24
	sta _objectarray_width, x
	lda #21
	sta _objectarray_height, x
/*
	lda #ANIMATION_TYPE_LOOP
	sta _animation_type, x
	lda #64
	sta _animation_start_frame, x
	lda #72
	sta _animation_end_frame, x
	lda #4
	sta _animation_speed, x
	jsr animation_setAnimation
*/
	lda #FRAME_ENEMIES_START + 0
	sta _animation_current_frame, x
	
	lda #2
	sta _objectarray_user_properties,x
	rts


lock_update:
	// Hit (TODO: Change)
	lda _objectarray_was_hit, x
	beq lock_u01
	dec _objectarray_hits, x
	lda _objectarray_hits, x
	beq lock_dead
lock_u01:

	jsr objectroutines_scrollObject

	// Animate
//	jsr animation_updateFrame

	// Draw
	jsr lock_draw
	rts

lock_draw:
	jsr objectroutines_drawObject
	rts

lock_dead:

	lda #0
	sta scroll_time_to_stop

	txa
	pha

	lda #OBJECT_EXPLOSION
	sta OBJECT_ZERO_PAGE_TYPE
	lda _objectarray_x_coord, x
	sta OBJECT_ZERO_PAGE_X_COORD
	lda _objectarray_x_msb_coord, x
	sta OBJECT_ZERO_PAGE_X_MSB_COORD
	lda _objectarray_y_coord, x
	sta OBJECT_ZERO_PAGE_Y_COORD
	lda #7
	sta OBJECT_ZERO_PAGE_COLOR
	jsr objectroutines_createObject

	pla
	tax

	lda #OBJECT_NONE
	sta _objectarray_type, x
	rts

