def calc_error(dX, dY, dZ, endstops):
	print("Координаты передвижения. X: {}; Y: {}; Z: {}.".format(dX, dY, dZ))
	dx = (dX + dY) * 80
	dy = (dX - dY) * 80
	dz = dZ * 800

	# print("Координаты передвижения для моторов. X: {}; Y: {}; Z: {}.".format(dx, dy, dz))


	# 0 - =; 1 - -; 2 - +;
	stepper_x_direction = 0 if dx >= 0 else 1
	stepper_y_direction = 0 if dy >= 0 else 1
	stepper_z_direction = 0 if dz >= 0 else 1

	# print("Поворот моторов. X: {}; Y: {}; Z: {}.".format(stepper_x_direction, stepper_y_direction, stepper_z_direction))

	num_x = abs(dx)
	num_y = abs(dy)
	num_z = abs(dz)
	num_x_now = 0
	num_y_now = 0
	num_z_now = 0

	# print("Координаты передвижения для моторов по модулю. X: {}; Y: {}; Z: {}.".format(num_x, num_y, num_z))

	if ((stepper_x_direction == 0) and (stepper_y_direction == 0)):
		x = 0 if ((num_x == 0) and (num_y == 0)) else 2
		if (num_x > num_y):
			y = 2
		else:
			if (num_x == num_y):
				y = 0
			else:
				y = 1


	if ((stepper_x_direction == 0) and (stepper_y_direction == 1)):
		y = 0 if ((num_x == 0) and (num_y == 0)) else 2
		if (num_x > num_y):
			x = 2
		else:
			if (num_x == num_y):
				x = 0
			else:
				x = 1

	if ((stepper_x_direction == 1) and (stepper_y_direction == 0)):
		y = 0 if ((num_x == 0) and (num_y == 0)) else 1
		if (num_y > num_x):
			x = 2
		else:
			if (num_x == num_y):
				x = 0
			else:
				x = 1

	if ((stepper_x_direction == 1) and (stepper_y_direction == 1)):
		x = 0 if ((num_x == 0) and (num_y == 0)) else 1
		if (num_y > num_x):
			y = 2
		else:
			if (num_x == num_y):
				y = 0
			else:
				y = 1

	# if (num_x == num_y):
	# 	y = 0
	# if (num_x == -num_y):
	# 	x = 0

	# 0 - =; 1 - -; 2 - +;
	if (x == 0):
		print("Нет движения по оси X")
	else:
		if (x == 1):
			print("Движение в минус по оси X")
		else:
			print("Движение в плюc по оси X")

	if (y == 0):
		print("Нет движения по оси Y")
	else:
		if (y == 1):
			print("Движение в минус по оси Y")
		else:
			print("Движение в плюc по оси Y")


	error = ((endstops[0]) and (x == 1) and ((num_x != num_x_now) or (num_y != num_y_now))) or (
				        (endstops[1]) and (x == 2) and ((num_x != num_x_now) or (num_y != num_y_now))) or \
	        ((endstops[2]) and (y == 1) and ((num_x != num_x_now) or (num_y != num_y_now))) or (
				        (endstops[3]) and (y == 2) and ((num_x != num_x_now) or (num_y != num_y_now))) or \
	        ((endstops[4]) and (stepper_z_direction == 1) and ((num_z != num_z_now) or (num_z != num_z_now))) or \
	                    ((endstops[5]) and (stepper_z_direction == 0) and ((num_z != num_z_now) or (num_z != num_z_now)))
	return x, y, error * 1

# print(calc_error(10, 0, 0, [0, 0, 0, 0, 0, 0]))

a = [
	[-10, -10],
	[-10, 0],
	[-10, 10],
	[0, -10],
	[0, 0],
	[0, 10],
	[10, -10],
	[10, 0],
	[10, 10]]

# 0 - =; 1 - -; 2 - +;
b = [
	[1, 1],
	[1, 0],
	[1, 2],
	[0, 1],
	[0, 0],
	[0, 2],
	[2, 1],
	[2, 0],
	[2, 2]]



for i in range(len(a)):
	x, y, error = calc_error(a[i][0], a[i][1], 0, [0, 0, 0, 0, 1, 1])

	print("Полученные результаты: x: {}, y: {}. Ожидаемые результаты: x: {}, y: {}. Ошибка: {}".format(x, y, b[i][0], b[i][1], error))