# Formeln der feuchten Luft

# (4.1)
def eq41x(mw, ml):
    """Berechnet die Wasseranteile xi_W und xi_L gemäß Gl. (4.1)."""
    """mw[kgW], ml[kgL]"""
    """ x[kgW/kgL] """
    x = mw / ml
    return x

# (4.5)
def eq45x(p, ps, phi):
    """Wassergehalt x gemäß Gl. (4.5)."""
    """ p[Pa], ps[Pa], φ """
    """ x[kgW/kgL] """
    x = 0.622*(phi*ps/(p - phi*ps))
    return x
def eq45phi(p, ps, x):
    """Relative Luftfeuchte φ gemäß Gl. (4.5)."""
    """ p[Pa], ps[Pa], x[kgW/kgL] """
    phi = (p/ps)*(x/(0.622 + x))
    return phi
def eq45xs(p, ps):
    """Relative Luftfeuchte φ gemäß Gl. (4.5)."""
    """ p[Pa], ps[Pa], x[kgW/kgL] """
    xs = 0.622*(ps/(p - ps))
    return xs
def eq45ps(p, x, phi):
    """Sättigungsdampfdruck ps gemäß Gl. (4.5)."""
    """ p[Pa], x[kgW/kgL], φ """
    ps = (p*x)/(0.622 + x)*(1/phi)
    return ps

# (4.8)
def eq48v(p, T, x):
    """Spezifisches Volumen v bei ungesättigter/gesättigter Luft gemäß Gl. (4.8)."""
    """ p[Pa], T[K], x[kgW/kgL] """
    """ v[m³/kg] """
    Rw = 461.5  # J/(kgK)
    v = ((Rw*T)/p)*((0.622 + x)/(1 + x))
    return v

# (4.9)
def eq49v(p, T, x, xs, v1):
    """Spezifisches Volumen v bei übersättigter Luft gemäß Gl. (4.9)."""
    """ p[Pa], T[K], x[kgW/kgL], xs[kgW/kgL], v1[m³/kg] """
    """ v[m³/kg] """
    Rw = 461.5  # J/(kgK)
    v = (1/(1+x))*(((Rw*T)/p)*(0.622+xs)+(x-xs)*v1)
    return v

# (4.10)
def eq410h(T, x):
    """Spezifische Enthalpie h bei ungesättigter/gesättigter Luft gemäß Gl. (4.10)."""
    """ T[°C], x[kgW/kgL] """
    """ h[kJ/kgL] """
    h = (1+1.86*x)*T+2501*x
    return h
def eq410T(h, x):
    """Temperatur T bei ungesättigter/gesättigter Luft gemäß Gl. (4.10)."""
    """ h[kJ/kgL], x[kgW/kgL] """
    """ T[°C] """
    T = (h - 2501*x)/(1 + 1.86*x)
    return T

# (4.11)
def eq411h(T, x, xs):
    """Spezifische Enthalpie h bei übersättigter Luft mit T>0°C gemäß Gl. (4.11)."""
    """ T[°C], x[kgW/kgL], xs[kgW/kgL] """
    """ h[kJ/kgL] """
    h = (1-2.33*xs+4.19*x)*T+2501*xs
    return h
def eq411T(h, x, xs):
    """Temperatur T bei übersättigter Luft mit T>0°C gemäß Gl. (4.11)."""
    """ h[kJ/kgL], x[kgW/kgL], xs[kgW/kgL] """
    """ T[°C] """
    T = (h - 2501*xs)/(1 - 2.33*xs + 4.19*x)
    return T

# (4.12)
def eq412h(T, x, xs):
    """Spezifische Enthalpie h bei übersättigter Luft mit T<0°C gemäß Gl. (4.11)."""
    """ T[°C], x[kgW/kgL], xs[kgW/kgL] """
    """ h[kJ/kgL] """
    h = (1-0.23*xs+2.09*x)*T+2835*xs-334*x
    return h
def eq412T(h, x, xs):
    """Temperatur T bei übersättigter Luft mit T<0°C gemäß Gl. (4.12)."""
    """ h[kJ/kgL], x[kgW/kgL], xs[kgW/kgL] """
    """ T[°C] """
    T = (h - 2835*xs + 334*x)/(1 - 0.23*xs + 2.09*x)
    return T