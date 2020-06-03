def choose_int(s):
	l = len(s)
	integ = []
	i = 0
	while i < l:
		s_int = ''
		a = s[i]
		while '0' <= a <= '9':
			s_int += a
			i += 1
			if i < l:
				a = s[i]
			else:
				break
		i += 1
		if s_int != '' and (i == l or s[i-1] == ','):
			integ.append(int(s_int))
	return integ

f = open("motor_x.txt", 'r')
def choose_int(s):
	l = len(s)
	integ = []
	i = 0
	while i < l:
		s_int = ''
		a = s[i]
		while '0' <= a <= '9':
			s_int += a
			i += 1
			if i < l:
				a = s[i]
			else:
				break
		i += 1
		if s_int != '' and (i == l or s[i-1] == ','):
			integ.append(int(s_int))
	return integ

print(choose_int(f.readline()))
print(choose_int(f.readline()))
print(choose_int(f.readline()))
print(choose_int(f.readline()))
print(choose_int(f.readline()))
f.close()