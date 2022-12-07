-- Tables of basic types.

create or replace type at_names is table of varchar2(30)
/

create or replace type at_varchars is table of varchar2(4000)
/

create or replace type at_numbers is table of number
/

create or replace type at_dates is table of date
/

-- Row with 10 varchar2 fileds.
create or replace type at_row10 as object (
    c1 varchar2(4000), c2 varchar2(4000), c3 varchar2(4000), c4 varchar2(4000), c5 varchar2(4000),
    c6 varchar2(4000), c7 varchar2(4000), c8 varchar2(4000), c9 varchar2(4000), c10 varchar2(4000),
    constructor function at_row10 return self as result,
    constructor function at_row10(c1 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2) return self as result,
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2) return self as result
)
/

create or replace type body at_row10 as
    constructor function at_row10 return self as result as
    begin
        return;
    end;
    constructor function at_row10(c1 varchar2) return self as result as
    begin
        self.c1 := c1;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8;
        return;
    end;
    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9;
        return;
    end;
end;
/

-- Table of rows with 10 varchar2 fileds.
create or replace type at_table10 is table of at_row10
/

-- Row with 30 varchar2 fileds.
create or replace type at_row30 as object (
    c1 varchar2(4000), c2 varchar2(4000), c3 varchar2(4000), c4 varchar2(4000), c5 varchar2(4000),
    c6 varchar2(4000), c7 varchar2(4000), c8 varchar2(4000), c9 varchar2(4000), c10 varchar2(4000),
    c11 varchar2(4000), c12 varchar2(4000), c13 varchar2(4000), c14 varchar2(4000), c15 varchar2(4000),
    c16 varchar2(4000), c17 varchar2(4000), c18 varchar2(4000), c19 varchar2(4000), c20 varchar2(4000),
    c21 varchar2(4000), c22 varchar2(4000), c23 varchar2(4000), c24 varchar2(4000), c25 varchar2(4000),
    c26 varchar2(4000), c27 varchar2(4000), c28 varchar2(4000), c29 varchar2(4000), c30 varchar2(4000),
    constructor function at_row30 return self as result,
    constructor function at_row30(c1 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2, c27 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2, c27 varchar2, c28 varchar2) return self as result,
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2, c27 varchar2, c28 varchar2, c29 varchar2) return self as result
)
/

create or replace type body at_row30 as
    constructor function at_row30 return self as result as
    begin
        return;
    end;
     constructor function at_row30(c1 varchar2) return self as result as
    begin
        self.c1 := c1;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22; self.c23 := c23;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22; self.c23 := c23; self.c24 := c24;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22; self.c23 := c23; self.c24 := c24; self.c25 := c25;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22; self.c23 := c23; self.c24 := c24; self.c25 := c25; self.c26 := c26;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2, c27 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22; self.c23 := c23; self.c24 := c24; self.c25 := c25; self.c26 := c26; self.c27 := c27;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2, c27 varchar2, c28 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22; self.c23 := c23; self.c24 := c24; self.c25 := c25; self.c26 := c26; self.c27 := c27; self.c28 := c28;
        return;
    end;
    constructor function at_row30(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2, c10 varchar2, c11 varchar2, c12 varchar2, c13 varchar2, c14 varchar2, c15 varchar2, c16 varchar2, c17 varchar2, c18 varchar2, c19 varchar2, c20 varchar2, c21 varchar2, c22 varchar2, c23 varchar2, c24 varchar2, c25 varchar2, c26 varchar2, c27 varchar2, c28 varchar2, c29 varchar2) return self as result as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9; self.c10 := c10; self.c11 := c11; self.c12 := c12; self.c13 := c13; self.c14 := c14; self.c15 := c15; self.c16 := c16; self.c17 := c17; self.c18 := c18; self.c19 := c19; self.c20 := c20; self.c21 := c21; self.c22 := c22; self.c23 := c23; self.c24 := c24; self.c25 := c25; self.c26 := c26; self.c27 := c27; self.c28 := c28; self.c29 := c29;
        return;
    end;
end;
/

-- Table of rows with 30 varchar2 fileds.
create or replace type at_table30 is table of at_row30
/

-- Row with 50 varchar2 fileds.
create or replace type at_row50 as object (
    c1 varchar2(4000), c2 varchar2(4000), c3 varchar2(4000), c4 varchar2(4000), c5 varchar2(4000),
    c6 varchar2(4000), c7 varchar2(4000), c8 varchar2(4000), c9 varchar2(4000), c10 varchar2(4000),
    c11 varchar2(4000), c12 varchar2(4000), c13 varchar2(4000), c14 varchar2(4000), c15 varchar2(4000),
    c16 varchar2(4000), c17 varchar2(4000), c18 varchar2(4000), c19 varchar2(4000), c20 varchar2(4000),
    c21 varchar2(4000), c22 varchar2(4000), c23 varchar2(4000), c24 varchar2(4000), c25 varchar2(4000),
    c26 varchar2(4000), c27 varchar2(4000), c28 varchar2(4000), c29 varchar2(4000), c30 varchar2(4000),
    c31 varchar2(4000), c32 varchar2(4000), c33 varchar2(4000), c34 varchar2(4000), c35 varchar2(4000),
    c36 varchar2(4000), c37 varchar2(4000), c38 varchar2(4000), c39 varchar2(4000), c40 varchar2(4000),
    c41 varchar2(4000), c42 varchar2(4000), c43 varchar2(4000), c44 varchar2(4000), c45 varchar2(4000),
    c46 varchar2(4000), c47 varchar2(4000), c48 varchar2(4000), c49 varchar2(4000), c50 varchar2(4000),
    constructor function at_row50 return self as result
)
/

create or replace type body at_row50 as
    constructor function at_row50 return self as result as
    begin return; end;
end;
/

-- Table of rows with 50 varchar2 fileds.
create or replace type at_table50 is table of at_row50
/

-- Row with 70 varchar2 fileds.
create or replace type at_row70 as object (
    c1 varchar2(4000), c2 varchar2(4000), c3 varchar2(4000), c4 varchar2(4000), c5 varchar2(4000),
    c6 varchar2(4000), c7 varchar2(4000), c8 varchar2(4000), c9 varchar2(4000), c10 varchar2(4000),
    c11 varchar2(4000), c12 varchar2(4000), c13 varchar2(4000), c14 varchar2(4000), c15 varchar2(4000),
    c16 varchar2(4000), c17 varchar2(4000), c18 varchar2(4000), c19 varchar2(4000), c20 varchar2(4000),
    c21 varchar2(4000), c22 varchar2(4000), c23 varchar2(4000), c24 varchar2(4000), c25 varchar2(4000),
    c26 varchar2(4000), c27 varchar2(4000), c28 varchar2(4000), c29 varchar2(4000), c30 varchar2(4000),
    c31 varchar2(4000), c32 varchar2(4000), c33 varchar2(4000), c34 varchar2(4000), c35 varchar2(4000),
    c36 varchar2(4000), c37 varchar2(4000), c38 varchar2(4000), c39 varchar2(4000), c40 varchar2(4000),
    c41 varchar2(4000), c42 varchar2(4000), c43 varchar2(4000), c44 varchar2(4000), c45 varchar2(4000),
    c46 varchar2(4000), c47 varchar2(4000), c48 varchar2(4000), c49 varchar2(4000), c50 varchar2(4000),
    c51 varchar2(4000), c52 varchar2(4000), c53 varchar2(4000), c54 varchar2(4000), c55 varchar2(4000),
    c56 varchar2(4000), c57 varchar2(4000), c58 varchar2(4000), c59 varchar2(4000), c60 varchar2(4000),
    c61 varchar2(4000), c62 varchar2(4000), c63 varchar2(4000), c64 varchar2(4000), c65 varchar2(4000),
    c66 varchar2(4000), c67 varchar2(4000), c68 varchar2(4000), c69 varchar2(4000), c70 varchar2(4000),
    constructor function at_row70 return self as result
)
/

create or replace type body at_row70 as
    constructor function at_row70 return self as result as
    begin return; end;
end;
/

-- Table of rows with 70 varchar2 fileds.
create or replace type at_table70 is table of at_row70
/

-- Row with 100 varchar2 fileds.
create or replace type at_row as object (
    c1 varchar2(4000), c2 varchar2(4000), c3 varchar2(4000), c4 varchar2(4000), c5 varchar2(4000),
    c6 varchar2(4000), c7 varchar2(4000), c8 varchar2(4000), c9 varchar2(4000), c10 varchar2(4000),
    c11 varchar2(4000), c12 varchar2(4000), c13 varchar2(4000), c14 varchar2(4000), c15 varchar2(4000),
    c16 varchar2(4000), c17 varchar2(4000), c18 varchar2(4000), c19 varchar2(4000), c20 varchar2(4000),
    c21 varchar2(4000), c22 varchar2(4000), c23 varchar2(4000), c24 varchar2(4000), c25 varchar2(4000),
    c26 varchar2(4000), c27 varchar2(4000), c28 varchar2(4000), c29 varchar2(4000), c30 varchar2(4000),
    c31 varchar2(4000), c32 varchar2(4000), c33 varchar2(4000), c34 varchar2(4000), c35 varchar2(4000),
    c36 varchar2(4000), c37 varchar2(4000), c38 varchar2(4000), c39 varchar2(4000), c40 varchar2(4000),
    c41 varchar2(4000), c42 varchar2(4000), c43 varchar2(4000), c44 varchar2(4000), c45 varchar2(4000),
    c46 varchar2(4000), c47 varchar2(4000), c48 varchar2(4000), c49 varchar2(4000), c50 varchar2(4000),
    c51 varchar2(4000), c52 varchar2(4000), c53 varchar2(4000), c54 varchar2(4000), c55 varchar2(4000),
    c56 varchar2(4000), c57 varchar2(4000), c58 varchar2(4000), c59 varchar2(4000), c60 varchar2(4000),
    c61 varchar2(4000), c62 varchar2(4000), c63 varchar2(4000), c64 varchar2(4000), c65 varchar2(4000),
    c66 varchar2(4000), c67 varchar2(4000), c68 varchar2(4000), c69 varchar2(4000), c70 varchar2(4000),
    c71 varchar2(4000), c72 varchar2(4000), c73 varchar2(4000), c74 varchar2(4000), c75 varchar2(4000),
    c76 varchar2(4000), c77 varchar2(4000), c78 varchar2(4000), c79 varchar2(4000), c80 varchar2(4000),
    c81 varchar2(4000), c82 varchar2(4000), c83 varchar2(4000), c84 varchar2(4000), c85 varchar2(4000),
    c86 varchar2(4000), c87 varchar2(4000), c88 varchar2(4000), c89 varchar2(4000), c90 varchar2(4000),
    c91 varchar2(4000), c92 varchar2(4000), c93 varchar2(4000), c94 varchar2(4000), c95 varchar2(4000),
    c96 varchar2(4000), c97 varchar2(4000), c98 varchar2(4000), c99 varchar2(4000), c100 varchar2(4000),
    constructor function at_row return self as result
)
/

create or replace type body at_row as
    constructor function at_row return self as result as begin return; end;
end;
/

-- Table of rows with 100 varchar2 fileds.
create or replace type at_table is table of at_row
/
