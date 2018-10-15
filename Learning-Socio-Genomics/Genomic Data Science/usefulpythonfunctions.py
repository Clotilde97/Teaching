def approximate_match(p, t):
    D = []
    for i in range(len(p)+1):
        D.append([0]*(len(t)+1))
       
    for i in range(len(p)+1):
        D[i][0] = i
    for i in range(len(t)+1):
        D[0][i] = 0
       
    for i in range(1, len(p)+1):
        for j in range(1, len(t)+1):
            distHor = D[i][j-1] + 1
            distVer = D[i-1][j] + 1
            if p[i-1] == t[j-1]:
                distDiag = D[i-1][j-1]
            else:
                distDiag = D[i-1][j-1] + 1
            D[i][j] = min(distHor, distVer, distDiag)
    return min(D[-1])


def boyer_moore(p, p_bm, t):
    """ Do Boyer-Moore matching. p=pattern, t=text,
        p_bm=BoyerMoore object for p """
    i = 0
    occurrences = []
    while i < len(t) - len(p) + 1:
        shift = 1
        mismatched = False
        for j in range(len(p)-1, -1, -1):
            if p[j] != t[i+j]:
                skip_bc = p_bm.bad_character_rule(j, t[i+j])
                skip_gs = p_bm.good_suffix_rule(j)
                shift = max(shift, skip_bc, skip_gs)
                mismatched = True
                break
        if not mismatched:
            occurrences.append(i)
            skip_gs = p_bm.match_skip()
            shift = max(shift, skip_gs)
        i += shift
    return occurrences

def findGCbypos(reads):
	gc=[0]*100
	totals=[0]*100
	for read in reads:
		for i in range(len(read)):
			if read[i]== `C' or read[i] == `G':
				gc[i]+=1
			totals[i]+=1
	for i in range(len(gc)):
		gc[i]/=float(totals[i])

def longestCommonPrefix(s1,s2):
	i=0
	while i < len(s1) and i < len(s2) and s1[i]==s2[i]:
		return s1[:i]

def naive(p, t):
    occurrences = []
    for i in range(len(t) - len(p) + 1):  # loop over alignments
        match = True
        for j in range(len(p)):  # loop over characters
            if t[i+j] != p[j]:  # compare characters
                match = False
                break
        if match:
            occurrences.append(i)  # all chars matched; record
    return occurrences
	
def naiveHamming(p,t,maxDistance):
	occurances=[]
	for i in xrange(len(t)-len(p)+1):
		nmm=0
		match=True
		for j in xrange(len(p)):
			if t[i+j]!=p[j]:
				nmm+=1
				if nmm>maxDistance:
					break
		if nmm <= maxDistance:
			occurences.append(i)
	return occurences

def phred33toQuality(qual):
	return ord(qual)-33
	
def readGenome(filename):
    genome = ''
    with open(filename, 'r') as f:
        for line in f:
            # ignore header line with genome information
            if not line[0] == '>':
                genome += line.rstrip()
    return genome

def readFastq(filename):
    sequences = []
    qualities = []
    with open(filename) as fh:
        while True:
            fh.readline()  # skip name line
            seq = fh.readline().rstrip()  # read base sequence
            fh.readline()  # skip placeholder line
            qual = fh.readline().rstrip() # base quality line
            if len(seq) == 0:
                break
            sequences.append(seq)
            qualities.append(qual)
    return sequences, qualities
	
def reverseComplement(s):
    complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A', 'N': 'N'}
    t = ''
    for base in s:
        t = complement[base] + t
    return t