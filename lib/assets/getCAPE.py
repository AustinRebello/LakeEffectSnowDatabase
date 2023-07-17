import math
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
     '  Option Explicit
     '  From "Thermodynamic Analysis Procedures at the National
     '        Severe Storms Forecast Center"  Preprints of the
     '        9th Conference of Weather Forecasting and Analysis.
     '        John A Hart
     '
     '  This function simply returns the temperature of a
     '  parcel of air at (TEMP,PRES), when lifted along a moist
     '  adiabat to the pressure level (NEWLVL), i.e.
     '  WETADIA(20,1000,850) = 13.7 Deg C.
     '
     '
     '  Temperature - Deg C          Pressure - mb
     '
     '  Modified for BUFKIT by Ed Mahoney  (Thanks John!)
     '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

def saturatedLFT(thm, p):
  pwrp, tone, t, eone = 0.0, 0.0, 0.0, 0.0
   
  rocp = 0.28571428
  if ((abs(p - 1000) - 0.001) <= 0):
    return thm
  else:
    pwrp = (p / 1000) ** rocp
    tone = (thm + 273.16) * pwrp - 273.16
    t = tone
    woto = WOBF(t)
    t = thm
    wotm= WOBF(t)
    eone = woto - wotm
    xRate = 1
    return x330(tone, eone, xRate, pwrp, thm)
    
def x300(eone, tone, ttwo, etwo, pwrp, thm):
  xRate = (ttwo - tone) / (etwo - eone)
  tone = ttwo
  eone = etwo
  return x330(tone, eone, xRate, pwrp, thm)
  
def x330(tone, eone, xRate, pwrp, thm):
  ttwo = tone - eone * xRate
  etwo = (ttwo + 273.16) / pwrp - 273.16
  t = ttwo 
  wot2 = WOBF(t)
  t = etwo
  woe2 = WOBF(t)
  etwo = etwo + wot2 - woe2 - thm
  eor = etwo * xRate
  if (abs(eor) - 0.1 <= 0):
    return (ttwo - eor)
  else:
    return x300(eone, tone, ttwo, etwo, pwrp, thm)

def wetLift(temp, pres, newLVL):
  t = 0.0
  th1 = 0.0
  tx = temp
  p = pres
  tha = xTheta(temp, pres)
  woth = WOBF(tha)
  wott = WOBF(tx)
  thm = tha - woth + wott

  return (saturatedLFT(thm, newLVL) + (newLVL - pres) * 0.3 / 500)

def WOBF(t):
  pol, p1, p2 = 0.0, 0.0, 0.0
  x = t - 20
  if(x <= 0):
    p1 = -0.000000032607217 + x * -3.8598073E-10
    p2 = -0.0000009671989 + x * p1
    pol = 1 + x * (-0.0088416605 + x * (0.00014714143 + x * p2))
    pol = pol * pol
    return (15.13 / (pol * pol))
  else:
    p1 = -1.2588129E-13 + x * 1.668828E-16
    p2 = -6.1059365E-09 + x * (3.9401551E-11 + x * p1)
    pol = x * (0.00000049618922 + x * p2)
     
    pol = 1 + x * (0.0036182989 + x * (-0.000013603273 + pol))
    pol = pol * pol
    return (29.93 / (pol * pol) + 0.96 * x - 14.8)


def xTheta(t, p):
  rocp = 0.28571428
  t = t + 273.16
  th1 = t *( 1000 / p) ** rocp
  return (th1 - 273.16)
  

#x = wetLift(20,1000,850)
#print(round(x,2))