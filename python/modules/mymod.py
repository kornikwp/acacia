# %python
# import mymod
# mymod.test('mymod.py')
# reload if needed: from imp import reload
# reload(mymod)
# OR: sum(len(line) for line in open('mymod.py'))
def countLines(name):
    file = open(name)
    return len(file.readlines( ))

def countChars(name):
    return len(open(name).read( ))

def test(name):
    return countLines(name), countChars(name), countLines2(name), countChars2(name),

#huge files
def countLines2(name):
    tot = 0
    for line in open(name):
        tot += 1
    return tot

def countChars2(name):
    tot = 0
    for line in open(name): 
        tot += len(line)
    return tot

#ver 1
# C:\Users\AR\Documents\GitHub\acacia\python>python mymod.py
# Set input file name:mymod.py
# (37, 774, 37, 774)

#if __name__ == '__main__':
#    print(test(input('Set input file name:')))

#ver. 2, run: C:\Users\AR\Documents\GitHub\acacia\python>python mymod.py mymod.py
# output: (37, 773, 37, 773)
if __name__ == '__main__':
    import sys
    print(test(sys.argv[1]))