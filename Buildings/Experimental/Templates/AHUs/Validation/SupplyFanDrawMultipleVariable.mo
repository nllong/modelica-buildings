within Buildings.Experimental.Templates.AHUs.Validation;
model SupplyFanDrawMultipleVariable
  extends NoEquipment(ahu(redeclare record RecordFanSup =
          Fans.Data.MultipleVariable (nFan=2), redeclare Fans.MultipleVariable
        fanSupDra));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end SupplyFanDrawMultipleVariable;
