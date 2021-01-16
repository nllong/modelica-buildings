model MinExampleOuter

  record EmptyRecord
  end EmptyRecord;

  record FullRecord
    parameter Real p = 0.0;
  end FullRecord;

  model Interface
    outer replaceable parameter EmptyRecord dat;
  end Interface;

  model Component1
    extends Interface;
  end Component1;

  model Component2
    extends Interface;
    parameter Real q = dat.p;
  end Component2;

  model System
    inner replaceable parameter EmptyRecord dat;
    replaceable Component1 com;
  end System;

  System s(
    redeclare FullRecord dat,
    redeclare Component2 com);

end MinExampleOuter;