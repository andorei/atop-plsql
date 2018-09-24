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
    c1 varchar2(4000),
    c2 varchar2(4000),
    c3 varchar2(4000),
    c4 varchar2(4000),
    c5 varchar2(4000),
    c6 varchar2(4000),
    c7 varchar2(4000),
    c8 varchar2(4000),
    c9 varchar2(4000),
    c10 varchar2(4000),
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
    constructor function at_row10 return self as result
    as
    begin
        return;
    end;

    constructor function at_row10(c1 varchar2) return self as result
    as
    begin
        self.c1 := c1;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8;
        return;
    end;

    constructor function at_row10(c1 varchar2, c2 varchar2, c3 varchar2, c4 varchar2, c5 varchar2, c6 varchar2, c7 varchar2, c8 varchar2, c9 varchar2) return self as result
    as
    begin
        self.c1 := c1; self.c2 := c2; self.c3 := c3; self.c4 := c4; self.c5 := c5; self.c6 := c6; self.c7 := c7; self.c8 := c8; self.c9 := c9;
        return;
    end;
end;
/

-- Table of rows with 10 varchar2 fileds.

create or replace type at_table10 is table of at_row10
/

-- Row with 100 varchar2 fileds.

create or replace type at_row as object (
    c1 varchar2(4000),
    c2 varchar2(4000),
    c3 varchar2(4000),
    c4 varchar2(4000),
    c5 varchar2(4000),
    c6 varchar2(4000),
    c7 varchar2(4000),
    c8 varchar2(4000),
    c9 varchar2(4000),
    c10 varchar2(4000),
    c11 varchar2(4000),
    c12 varchar2(4000),
    c13 varchar2(4000),
    c14 varchar2(4000),
    c15 varchar2(4000),
    c16 varchar2(4000),
    c17 varchar2(4000),
    c18 varchar2(4000),
    c19 varchar2(4000),
    c20 varchar2(4000),
    c21 varchar2(4000),
    c22 varchar2(4000),
    c23 varchar2(4000),
    c24 varchar2(4000),
    c25 varchar2(4000),
    c26 varchar2(4000),
    c27 varchar2(4000),
    c28 varchar2(4000),
    c29 varchar2(4000),
    c30 varchar2(4000),
    c31 varchar2(4000),
    c32 varchar2(4000),
    c33 varchar2(4000),
    c34 varchar2(4000),
    c35 varchar2(4000),
    c36 varchar2(4000),
    c37 varchar2(4000),
    c38 varchar2(4000),
    c39 varchar2(4000),
    c40 varchar2(4000),
    c41 varchar2(4000),
    c42 varchar2(4000),
    c43 varchar2(4000),
    c44 varchar2(4000),
    c45 varchar2(4000),
    c46 varchar2(4000),
    c47 varchar2(4000),
    c48 varchar2(4000),
    c49 varchar2(4000),
    c50 varchar2(4000),
    c51 varchar2(4000),
    c52 varchar2(4000),
    c53 varchar2(4000),
    c54 varchar2(4000),
    c55 varchar2(4000),
    c56 varchar2(4000),
    c57 varchar2(4000),
    c58 varchar2(4000),
    c59 varchar2(4000),
    c60 varchar2(4000),
    c61 varchar2(4000),
    c62 varchar2(4000),
    c63 varchar2(4000),
    c64 varchar2(4000),
    c65 varchar2(4000),
    c66 varchar2(4000),
    c67 varchar2(4000),
    c68 varchar2(4000),
    c69 varchar2(4000),
    c70 varchar2(4000),
    c71 varchar2(4000),
    c72 varchar2(4000),
    c73 varchar2(4000),
    c74 varchar2(4000),
    c75 varchar2(4000),
    c76 varchar2(4000),
    c77 varchar2(4000),
    c78 varchar2(4000),
    c79 varchar2(4000),
    c80 varchar2(4000),
    c81 varchar2(4000),
    c82 varchar2(4000),
    c83 varchar2(4000),
    c84 varchar2(4000),
    c85 varchar2(4000),
    c86 varchar2(4000),
    c87 varchar2(4000),
    c88 varchar2(4000),
    c89 varchar2(4000),
    c90 varchar2(4000),
    c91 varchar2(4000),
    c92 varchar2(4000),
    c93 varchar2(4000),
    c94 varchar2(4000),
    c95 varchar2(4000),
    c96 varchar2(4000),
    c97 varchar2(4000),
    c98 varchar2(4000),
    c99 varchar2(4000),
    c100 varchar2(4000),
    constructor function at_row return self as result
)
/

create or replace type body at_row as
    constructor function at_row return self as result
    as
    begin
        return;
    end;
end;
/

-- Table of rows with 100 varchar2 fileds.

create or replace type at_table is table of at_row
/
