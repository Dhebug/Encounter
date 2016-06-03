#!/usr/bin/python

cur_line = 0

# search space size
sp_sz = 312

# each possible initial values
# initial scanline
sp_lines = list(range(sp_sz))
# initial Hz (312 for 50Hz or 260 for 60Hz)
sp_hz = [260 for x in range(sp_sz)]


# delta to current "line" counter
sp_delta = list(range(sp_sz))

#print sp_lines

#print sp_hz


lf = open("out_l.dat", "w")
hf = open("out_f.dat", "w")
df = open("out_d.dat", "w")


# converges to delta range: -112 -1 in 4 pages
def test_vblank_force_60():
	n_lines = sp_sz
	for p in range(10):
		for l in range(sp_sz):
			sl = 312 - l
			for i in range(sp_sz):
				sp_lines[i] = (sp_lines[i] + 1) % sp_hz[i]
				sp_delta[i] = sp_lines[i] - l
				if sp_lines[i] < 200:
					if l < 200:
						sp_hz[i] = 260
					else:
						sp_hz[i] = 312#260
		#print sp_delta
		print "delta range: %d\t%d\t%d" % (min(sp_delta), max(sp_delta), abs(max(sp_delta)-min(sp_delta)))

# converges to delta range: -110 -1 in 10 but then screws up
def test_line_by_line_backwards():
	n_lines = sp_sz
	for p in range(20):
		for l in range(sp_sz):
			#sl = 312 - l
			for i in range(sp_sz):
#				sp_lines[i] = (sp_lines[i] + 1) % sp_hz[i]
				n_sp_line = (sp_lines[i] + 1) % sp_hz[i]
				#if n_sp_line < 0:
				#print "!? (%d + 1) %% %d = %d" % (sp_lines[i], sp_hz[i], n_sp_line)
				sp_lines[i] = n_sp_line
				sp_delta[i] = sp_lines[i] - l
				if l == 200 - p * 10:
					if sp_lines[i] < 200:
						sp_hz[i] = 312
					else:
						sp_hz[i] = 260
			#print len(sp_lines)
#		print sp_delta
#		print sp_hz
		print "delta range: %d\t%d\t%d" % (min(sp_delta), max(sp_delta), abs(max(sp_delta)-min(sp_delta)))

# converges to delta range: -263	-212	51
def test_1_3_mul():
	n_lines = sp_sz
	for p in range(50):
		#print "Page %d" % p
		for l in range(sp_sz):
			#print l
			#sl = 312 - l
			for i in range(sp_sz):
#				sp_lines[i] = (sp_lines[i] + 1) % sp_hz[i]
				n_sp_line = (sp_lines[i] + 1) % sp_hz[i]
				if n_sp_line < 0:
					print "!? (%d + 1) %% %d = %d" % (sp_lines[i], sp_hz[i], n_sp_line)
#				if i == 0 and sp_lines[i] != l:
#					print "!? %d != %d" % (sp_lines[i], l)
				sp_delta[i] = sp_lines[i] - l
				sp_lines[i] = n_sp_line
				# outside of displayable RAM, can't be changed
				if sp_lines[i] >= 224:
					continue
#				if l > 224:# and (l % (p+1)):
				if l > 224:# and (l % (p+1)):
					if sp_lines[i] < 1 * p:
						sp_hz[i] = 260
					elif sp_lines[i] < 2 * p:
						sp_hz[i] = 312
#						sp_hz[i] = 260
#					else:
#				if p > 30:# and (l % (p+1)):
#					if sp_lines[i] <= 200:
#						sp_hz[i] = 312
			#print len(sp_lines)
#		print sp_delta
#		print sp_hz
		print "delta range: %d\t%d\t%d" % (min(sp_delta), max(sp_delta), abs(max(sp_delta)-min(sp_delta)))

# converges to delta range: -110 -1 in 10 but then screws up
def test_1():
	n_lines = sp_sz
	for p in range(100):
		#print "Page %d" % p
		lf.write('\t'.join(map(str, sp_lines)))
		lf.write('\n')
		hf.write('\t'.join(map(str, sp_hz)))
		hf.write('\n')
		df.write('\t'.join(map(str, sp_delta)))
		df.write('\n')
		for l in range(sp_sz):
#			lf.write('\t'.join(map(str, sp_lines)))
#			lf.write('\n')
#			hf.write('\t'.join(map(str, sp_hz)))
#			hf.write('\n')
#			df.write('\t'.join(map(str, sp_delta)))
#			df.write('\n')
			#print l
			#sl = 312 - l
#			print ', '.join(map(str, sp_lines))
			for i in range(sp_sz):
#				sp_lines[i] = (sp_lines[i] + 1) % sp_hz[i]
				n_sp_line = (sp_lines[i] + 1) % sp_hz[i]
				if n_sp_line < 0:
					print "!? (%d + 1) %% %d = %d" % (sp_lines[i], sp_hz[i], n_sp_line)
#				if i == 0 and sp_lines[i] != l:
#					print "!? %d != %d" % (sp_lines[i], l)
				sp_delta[i] = sp_lines[i] - l
				sp_lines[i] = n_sp_line
				# outside of displayable RAM, can't be changed
				if sp_lines[i] >= 224:
					continue
#				if l > 224:# and (l % (p+1)):
				if p <= 30 and l < 2:# and (l % (p+1)):
					if sp_lines[i] < 1 * p:
						sp_hz[i] = 260
					elif sp_lines[i] < 3 * p:
						sp_hz[i] = 312
#						sp_hz[i] = 260
#					else:
				if p > 30 and p < 50:# and (l % (p+1)):
					if sp_lines[i] < 224:
						sp_hz[i] = 312
			#print len(sp_lines)
#		print sp_delta
#		print sp_hz
#			print "%d delta range: %d\t%d\t%d" % (l, min(sp_delta), max(sp_delta), abs(max(sp_delta)-min(sp_delta)))
		print "delta range: %d\t%d\t%d" % (min(sp_delta), max(sp_delta), abs(max(sp_delta)-min(sp_delta)))
	if 260 in sp_hz:
		print "failed to resync:"
		print sp_hz


# converges to delta range: -110 -1 in 10 but then screws up
def test_2():
	n_lines = sp_sz
	for p in range(100):
		#print "Page %d" % p
		lf.write('\t'.join(map(str, sp_lines)))
		lf.write('\n')
		hf.write('\t'.join(map(str, sp_hz)))
		hf.write('\n')
		df.write('\t'.join(map(str, sp_delta)))
		df.write('\n')
		for l in range(sp_sz):
#			lf.write('\t'.join(map(str, sp_lines)))
#			lf.write('\n')
#			hf.write('\t'.join(map(str, sp_hz)))
#			hf.write('\n')
#			df.write('\t'.join(map(str, sp_delta)))
#			df.write('\n')
			#print l
			#sl = 312 - l
#			print ', '.join(map(str, sp_lines))
			for i in range(sp_sz):
#				sp_lines[i] = (sp_lines[i] + 1) % sp_hz[i]
				n_sp_line = (sp_lines[i] + 1) % sp_hz[i]
				if n_sp_line < 0:
					print "!? (%d + 1) %% %d = %d" % (sp_lines[i], sp_hz[i], n_sp_line)
#				if i == 0 and sp_lines[i] != l:
#					print "!? %d != %d" % (sp_lines[i], l)
				sp_delta[i] = sp_lines[i] - l
				sp_lines[i] = n_sp_line
				# outside of displayable RAM, can't be changed
				if sp_lines[i] >= 224:
					continue
#				if l > 224:# and (l % (p+1)):
				if p <= 30 and l < 2:# and (l % (p+1)):
					if sp_lines[i] < 1 * p:
						sp_hz[i] = 260
					elif sp_lines[i] < 3 * p:
						sp_hz[i] = 312
#						sp_hz[i] = 260
#					else:
				if p > 30 and p < 50:# and (l % (p+1)):
					if sp_lines[i] < 224:
						sp_hz[i] = 312
			#print len(sp_lines)
#		print sp_delta
#		print sp_hz
#			print "%d delta range: %d\t%d\t%d" % (l, min(sp_delta), max(sp_delta), abs(max(sp_delta)-min(sp_delta)))
		print "delta range: %d\t%d\t%d" % (min(sp_delta), max(sp_delta), abs(max(sp_delta)-min(sp_delta)))
	if 260 in sp_hz:
		print "failed to resync:"
		print sp_hz


#test_vblank_force_60()
#test_line_by_line_backwards()
#test_1_3_mul()
#test_1()
test_2()


lf.close();
hf.close();
df.close();

