# File classtree.py
# %python
# joining namespace of classes
#wspinanie sie w gore drzewa dziedziczenia za pomoca laczy przestrzeni nazw, wyswietlajace wyzsze klasy nadrzedne z wcieciem
def classtree(cls, indent):
     print('.' * indent, cls.__name__)     #Wyswietlenie tu nazwy klasy
     for supercls in cls.__bases__:        #Rekurencja po wszystkich klasach nadrzednych 
         classtree(supercls, indent +3)    #Moze odwiedzic klase nadrzedna wiecej niz raz

def instancetree(inst):
    print('Tree',inst)
    classtree(inst.__class__,3)

def selftest():
    class A: pass
    class B(A): pass
    class C(A): pass
    class D(B,C): pass
    class E: pass
    class F(D,E): pass
    instancetree(B())
    instancetree(F())

if __name__ == "__main__":
    selftest()