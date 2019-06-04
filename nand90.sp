************ Library *************
.prot
.inc '90nm.txt'
.unprot

********* Params*******
.param			Lmin=90n
+Vdd= 1.2V

.global	Vdd
.temp	25
****** Sources ******
VSupply	 Vs	0   DC		Vdd
VinA	A	0   pulse  0  Vdd  2ns   100ps 100ps   15ns    30ns
VinB	B	0   pulse  0  Vdd  2ns  100ps 100ps   23ns    50ns

***************************** NAND ****************************
.SUBCKT Mynand inA inB GND NODE   AOUT
Mp3     AOUT     inB     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mp4     AOUT     inA     NODE    NODE    pmos    l ='Lmin'    w ='2*Lmin'
Mn5     AOUT     inA     mid     mid     nmos    l ='Lmin'    w ='2*Lmin'
Mn6     mid      inB     GND     GND     nmos    l ='Lmin'    w ='2*Lmin'
.ENDS Mynand

**************************** CIRCUIT ***************************

X1 A B 0 Vs out Mynand

*********Type of Analysis***
.tran  0.25ns  200ns 

.MEASURE TRAN tphl
 + trig V(A) val = '0.5 * Vdd'  rise = 1  targ V(out)  val = '0.5 * Vdd' fall = 1

.MEASURE TRAN tplh
+ trig V(A) val = '0.5 * Vdd' fall = 1 targ V(out) val = '0.5 * Vdd'  rise = 1

.MEASURE TRAN tpd  param = '0.5 * (tphl + tplh)'


.MEASURE TRAN t_rise
+ trig V(out) val = '0.1*Vdd'  rise = 1
+ targ V(out) val = '0.9*Vdd'  rise = 1

.MEASURE TRAN t_fall
+ trig V(out) val = '0.9*Vdd'  fall = 1
+ targ V(out) val = '0.1*Vdd'  fall = 1

.MEASURE highest_freq param = '1 /(t_rise + t_fall)'

.END
