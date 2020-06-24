( Probe Accuracy Test                                   )
( by Chris for use on Tormach Pathpilot                 )
(                                                       )
( This program  probes a 'setting ring' every degree    )
( and logs the results                                  )
( Results can be imported into Google Sheets to give    )
( an accuracy report                                    )

(Configuration section)
G21   (MM)

( Setting Ring Diameter)
#<Diameter>=87

(Nominal Diameter of Probe Tip) 
#<ProbeTipDia>=4

(Diameter to probe from )
#<StartDiameter>=#<Diameter> - #<ProbeTipDia>/2 -1

(Angle Increment . This and Loops below decides the number of probes done)
#<AngleInc>=1

(How many times to go round the Circle)
#<loops>=1

(Probe Speeds in mm/min)
#<RoughProbe>=500
#<FinalProbe>=50

(Z Safe travel height mm)
#<ZSafety>=10
(Z Probe Height mm)
#<ZProbe>=-10


(End configuration section)

(LOGOPEN,/Dropbox/Tormach/gcode/onedeg.txt)

#<Angle>=0 

G0 Z#<ZSafety>
G0 X0 Y0
G1 Z#<Zprobe> F#<RoughProbe>


o1 while [#<Angle> lt [#<loops> * 360]]
	
	(Calculate start and target positions)
    #<sxtarg> = [ SIN[#<Angle>] * #<StartDiameter> / 2.0 ]
    #<sytarg> = [ COS[#<Angle>] * #<StartDiameter> / 2.0 ]
    #<xtarg> = [ SIN[#<Angle>] * #<Diameter> / 2.0 ]
    #<ytarg> = [ COS[#<Angle>] * #<Diameter> / 2.0]

    G0 X#<sxtarg> Y#<sytarg>
    G38.3 X#<xtarg> Y#<ytarg> F#<RoughProbe>

( Untrip Probe and do final fine probe)
	G38.4 X0 Y0 F#<FinalProbe>
        G38.2 X#<xtarg> Y#<ytarg> F#<FinalProbe>
	
    
	
    (LOG, #<Angle>,#5061,#5062)

	#<Angle> = [#<Angle> + #<AngleInc> ]
	
o1 endwhile

(LOGCLOSE)
G0 Z#<ZSafety>
G0 X0 Y0
M2
