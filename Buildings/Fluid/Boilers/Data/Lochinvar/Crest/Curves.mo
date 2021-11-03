within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record Curves "Efficiency curves"
  extends Buildings.Fluid.Boilers.Data.Generic(
    effCur=
      [0,    294.174111359682, 299.779381058911, 305.316293810589, 310.921563509818, 316.458476261496, 322.040960311542, 327.600658712403, 333.137571464081, 338.742841163311, 344.279753914988;
       0.05,0.991213389121339,0.983995815899581,0.973640167364016,0.958577405857740,0.940690376569037,0.919665271966527,0.898953974895397,0.886087866108786,0.881066945606694,0.879811715481171;
        0.5,0.988075313807531,0.981171548117155,0.968619246861924,0.952301255230125,0.931903765690376,0.907426778242677,0.890794979079498,0.882635983263598,0.878242677824267,0.876987447698744;
          1,0.969560669456067,0.962656903765690,0.951046025104602,0.935041841004184,0.917154811715481,0.896443514644351,0.884832635983263,0.878242677824267,0.874476987447698,0.873535564853556]);
end Curves;
