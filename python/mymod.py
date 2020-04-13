# %python
# import mymod
# mymod.test('mymod.py')
# reload if needed: from imp import reload
# reload(mymod)
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