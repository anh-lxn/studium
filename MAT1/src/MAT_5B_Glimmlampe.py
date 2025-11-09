import matplotlib.pyplot as plt
import numpy as np

# Kennlinie
U_0 = 180
U_1 = 2
U_2 = 1
b = 1.1
c = 0.07
d = 0.035
I = np.arange(0, 101, 1)

def U(I):
 return U_0 + U_1 * I**b * np.exp(-c*I) + U_2 * np.exp(d*I)

### Empfindlichkeit
I_1 = 20
I_2 = 35
I_3 = 70
# Tangentenliniearisierung
def ableitung_von_U(I):
    return (((b*U_1/I)-c*U_1)*I**b *np.exp(-c*I) + U_2 * d * np.exp(d*I))

# y = m*(x-x1) + y1
def tangente(x,x1,y1):
    return (ableitung_von_U(x1)*(x-x1)+y1)

IRange1 = np.linspace(I_1-10,I_1+10, 100) #
IRange2 = np.linspace(I_2-10,I_2+10, 100) #
IRange3 = np.linspace(I_3-10,I_3+10, 100) #

# Sekantenliniearisierung
dI = 10
def anstieg_sekante(x):
   return ((U(x+dI) - U(x-dI))/2*dI*0.01)
def sekante(x,x1,y1): # y = m*(x-x1) + y1
    return(anstieg_sekante(x1)*(x-x1)+y1)


IRange1_sekante = np.linspace(I_1-dI-20,I_1-dI+20, 100) #
IRange2_sekante = np.linspace(I_2-dI-20,I_2-dI+20, 100) #
IRange3_sekante = np.linspace(I_3-dI-20,I_3-dI+20, 100) #


# Plot
plt.plot(I, U(I))

# Tangenten
plt.scatter(I_1, U(I_1), c="C1", s=50)
plt.plot(IRange1, tangente(IRange1, I_1, U(I_1)), 'C1--', linewidth=2, label="Tangente bei I₁")
plt.scatter(I_2, U(I_2), c="C1", s=50)
plt.plot(IRange2, tangente(IRange2, I_2, U(I_2)), 'C1--', linewidth=2, label="Tangente bei I₂")
plt.scatter(I_3, U(I_3), c="C1", s=50)
plt.plot(IRange3, tangente(IRange3, I_3, U(I_3)), 'C1--', linewidth=2, label="Tangente bei I₃")

# Sekanten
plt.scatter(I_1 - dI, U(I_1 - dI), c="C2", s=50)
plt.plot(IRange1_sekante, sekante(IRange1_sekante, I_1 - dI, U(I_1 - dI)), 'C2--', linewidth=2, label="Sekante bei I₁")
plt.scatter(I_2 - dI, U(I_2 - dI), c="C2", s=50)
plt.plot(IRange2_sekante, sekante(IRange2_sekante, I_2 - dI, U(I_2 - dI)), 'C2--', linewidth=2, label="Sekante bei I₂")
plt.scatter(I_3 - dI, U(I_3 - dI), c="C2", s=50)
plt.plot(IRange3_sekante, sekante(IRange3_sekante, I_3 - dI, U(I_3 - dI)), 'C2--', linewidth=2, label="Sekante bei I₃")

# Achsenbeschriftung & Legende
plt.xlabel("I in mA")
plt.ylabel("U in V")
plt.title("Kennlinie der Glimmlampe U=f(I)")
plt.grid()
plt.legend(loc="best")
plt.show()

