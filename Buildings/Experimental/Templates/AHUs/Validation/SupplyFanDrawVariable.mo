within Buildings.Experimental.Templates.AHUs.Validation;
model SupplyFanDrawVariable
  extends NoEquipment(ahu(redeclare record RecordFanSup =
          Fans.Data.SingleConstant, redeclare Fans.SingleVariable fanSupDra));

end SupplyFanDrawVariable;
