extends Area2D
signal hit

@export var speed=400
var screen_size
var collision_half_size:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size=get_viewport_rect().size
	var capsule=$CollisionShape2D.shape as CapsuleShape2D
	collision_half_size=Vector2(capsule.radius,0.5*capsule.height)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity=Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y=-1
	if Input.is_action_pressed("move_down"):
		velocity.y=1
	if Input.is_action_pressed("move_left"):
		velocity.x=-1
	if Input.is_action_pressed("move_right"):
		velocity.x=1
		
	if velocity.length() >0 :
		velocity=velocity.normalized()*speed
		
		if velocity.x!=0:	
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h=velocity.x<0
			$AnimatedSprite2D.flip_v=false
		elif velocity.y!=0:	
			$AnimatedSprite2D.play("up")
			$AnimatedSprite2D.flip_v=velocity.y>0
			$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity*delta
	position = position.clamp(collision_half_size,screen_size-collision_half_size)
		
		


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled",true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled=false
	
	
	
