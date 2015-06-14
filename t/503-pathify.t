# perl
# t/502-getters.t - Tests of methods which get data out of object
use strict;
use warnings;
use Carp;
use utf8;

use lib ('./lib');
use Parse::File::Taxonomy::Index;
use Parse::File::Taxonomy::Path;
use Test::More qw(no_plan); # tests => 12;
use Scalar::Util qw( reftype );
use Data::Dump;

my ($obj, $source, $expect);
my ($exp_fields, $exp_data_records);

my $path_fields = [
    "path","vertical","currency_code","wholesale_price","retail_price","is_actionable"
];
my $path_data_records = [
    ["|Alpha","Auto","USD","","","0"],
    ["|Alpha|Epsilon","Auto","USD","","","0"],
    ["|Alpha|Epsilon|Kappa","Auto","USD","0.50","0.60","1"],
    ["|Alpha|Zeta","Auto","USD","","","0"],
    ["|Alpha|Zeta|Lambda","Auto","USD","0.40","0.50","1"],
    ["|Alpha|Zeta|Mu","Auto","USD","0.40","0.50","0"],
    ["|Beta","Electronics","JPY","","","0"],
    ["|Beta|Eta","Electronics","JPY","0.35","0.45","1"],
    ["|Beta|Theta","Electronics","JPY","0.35","0.45","1"],
    ["|Gamma","Travel","EUR","","","0"],
    ["|Gamma|Iota","Travel","EUR","","","0"],
    ["|Gamma|Iota|Nu","Travel","EUR","0.60","0.75","1"],
    ["|Delta","Life Insurance","USD","0.25","0.30","1"],
];

{
    $source = "./t/data/delta.csv";
    note($source);
    $obj = Parse::File::Taxonomy::Index->new( {
        file    => $source,
    } );
    ok(defined $obj, "new() returned defined value");
    isa_ok($obj, 'Parse::File::Taxonomy::Index');

    my $rv = $obj->pathify_as_array_ref;
    ok($rv, "pathify_as_array_ref() returned true value");
    ok(ref($rv), "pathify_as_array_ref() returned reference");
    is(reftype($rv), 'ARRAY', "pathify_as_array_ref() returned array reference");

    $exp_fields = [
        "path",
        "vertical",
        "currency_code",
        "wholesale_price",
        "retail_price",
        "is_actionable",
    ];
    is_deeply($rv->[0], $exp_fields, "Got expected columns");
    $expect = 1;
    for my $i (1 .. $#{$rv}) {
        if (reftype($rv->[$i]->[0]) ne 'ARRAY') {
            $expect = 0;
            last;
        }
    }
    ok($expect, "Each data record has array ref in first column");

    my $path_obj = Parse::File::Taxonomy::Path->new( {
        components => {
            fields          => $path_fields,
            data_records    => $path_data_records,
        },
    } );
    ok(defined $path_obj, "new() returned defined value");
    isa_ok($path_obj, 'Parse::File::Taxonomy::Path');
    my $path_fadrpc = $path_obj->fields_and_data_records_path_components;
    is_deeply($path_fadrpc, $rv,
        "taxonomy-by-index and taxonomy-by-path are equivalent");
}

{
    $source = "./t/data/zeta.csv";
    note($source);
    $obj = Parse::File::Taxonomy::Index->new( {
        file                => $source,
        id_col              => 'my_id',
        parent_id_col       => 'my_parent_id',
        component_col       => 'my_name',
    } );
    ok(defined $obj, "new() returned defined value");
    isa_ok($obj, 'Parse::File::Taxonomy::Index');

    $exp_fields = ["my_id","my_parent_id","my_name","vertical","currency_code","wholesale_price","retail_price","is_actionable"];
    is_deeply($obj->fields, $exp_fields, "Got expected columns");
    $exp_data_records = [
        [1, "", "Alpha", "Auto", "USD", "", "", 0],
        [3, 1, "Epsilon", "Auto", "USD", "", "", 0],
        [4, 3, "Kappa", "Auto", "USD", "0.50", "0.60", 1],
        [5, 1, "Zeta", "Auto", "USD", "", "", 0],
        [6, 5, "Lambda", "Auto", "USD", "0.40", "0.50", 1],
        [7, 5, "Mu", "Auto", "USD", "0.40", "0.50", 0],
        [2, "", "Beta", "Electronics", "JPY", "", "", 0],
        [8, 2, "Eta", "Electronics", "JPY", 0.35, 0.45, 1],
        [9, 2, "Theta", "Electronics", "JPY", 0.35, 0.45, 1],
        [10, "", "Gamma", "Travel", "EUR", "", "", 0],
        [11, 10, "Iota", "Travel", "EUR", "", "", 0],
        [12, 11, "Nu", "Travel", "EUR", "0.60", 0.75, 1],
        [13, "", "Delta", "Life Insurance", "USD", 0.25, "0.30", 1],
    ];
    is_deeply($obj->data_records, $exp_data_records, "Got expected data records");
    $expect = [
        $exp_fields,
        @{$exp_data_records},
    ];
    is_deeply($obj->fields_and_data_records, $expect, "Got expected fields and data records");

    $expect = 0;
    is($obj->id_col_idx, $expect, "Got expected index of 'id' column");
    $expect = 'my_id';
    is($obj->id_col, $expect, "Got expected name of 'id' column");
    $expect = 1;
    is($obj->parent_id_col_idx, $expect, "Got expected index of 'parent_id' column");
    $expect = 'my_parent_id';
    is($obj->parent_id_col, $expect, "Got expected name of 'parent_id' column");
    $expect = 2;
    is($obj->component_col_idx, $expect, "Got expected index of 'component' column");
    $expect = 'my_name';
    is($obj->component_col, $expect, "Got expected name of 'component' column");

    my $rv = $obj->pathify_as_array_ref;
    ok($rv, "pathify_as_array_ref() returned true value");
    ok(ref($rv), "pathify_as_array_ref() returned reference");
    is(reftype($rv), 'ARRAY', "pathify_as_array_ref() returned array reference");

    $exp_fields = [
        "path",
        "vertical",
        "currency_code",
        "wholesale_price",
        "retail_price",
        "is_actionable",
    ];
    is_deeply($rv->[0], $exp_fields, "Got expected columns");
    $expect = 1;
    for my $i (1 .. $#{$rv}) {
        if (reftype($rv->[$i]->[0]) ne 'ARRAY') {
            $expect = 0;
            last;
        }
    }
    ok($expect, "Each data record has array ref in first column");

    my $path_obj = Parse::File::Taxonomy::Path->new( {
        components => {
            fields          => $path_fields,
            data_records    => $path_data_records,
        },
    } );
    ok(defined $path_obj, "new() returned defined value");
    isa_ok($path_obj, 'Parse::File::Taxonomy::Path');
    my $path_fadrpc = $path_obj->fields_and_data_records_path_components;
    is_deeply($path_fadrpc, $rv,
        "taxonomy-by-index and taxonomy-by-path are equivalent");
}

{
    note("'components' interface");
    $exp_fields = ["id","parent_id","name","vertical","currency_code","wholesale_price","retail_price","is_actionable"];
    $exp_data_records    = [
        ["1","","Alpha","Auto","USD","","","0"],
        ["3","1","Epsilon","Auto","USD","","","0"],
        ["4","3","Kappa","Auto","USD","0.50","0.60","1"],
        ["5","1","Zeta","Auto","USD","","","0"],
        ["6","5","Lambda","Auto","USD","0.40","0.50","1"],
        ["7","5","Mu","Auto","USD","0.40","0.50","0"],
        ["2","","Beta","Electronics","JPY","","","0"],
        ["8","2","Eta","Electronics","JPY","0.35","0.45","1"],
        ["9","2","Theta","Electronics","JPY","0.35","0.45","1"],
        ["10","","Gamma","Travel","EUR","","","0"],
        ["11","10","Iota","Travel","EUR","","","0"],
        ["12","11","Nu","Travel","EUR","0.60","0.75","1"],
        ["13","","Delta","Life Insurance","USD","0.25","0.30","1"],
    ];
    $obj = Parse::File::Taxonomy::Index->new( {
        components => {
            fields => $exp_fields,
            data_records => $exp_data_records,
        },
    } );
    ok(defined $obj, "new() returned defined value");
    isa_ok($obj, 'Parse::File::Taxonomy::Index');

    is_deeply($obj->fields, $exp_fields, "Got expected columns");
    is_deeply($obj->data_records, $exp_data_records, "Got expected data records");
    $expect = [
        $exp_fields,
        @{$exp_data_records},
    ];
    is_deeply($obj->fields_and_data_records, $expect, "Got expected fields and data records");

    $expect = 0;
    is($obj->id_col_idx, $expect, "Got expected index of 'id' column");
    $expect = 'id';
    is($obj->id_col, $expect, "Got expected name of 'id' column");
    $expect = 1;
    is($obj->parent_id_col_idx, $expect, "Got expected index of 'parent_id' column");
    $expect = 'parent_id';
    is($obj->parent_id_col, $expect, "Got expected name of 'parent_id' column");
    $expect = 2;
    is($obj->component_col_idx, $expect, "Got expected index of 'component' column");
    $expect = 'name';
    is($obj->component_col, $expect, "Got expected name of 'component' column");

    my $rv = $obj->pathify_as_array_ref;
    ok($rv, "pathify_as_array_ref() returned true value");
    ok(ref($rv), "pathify_as_array_ref() returned reference");
    is(reftype($rv), 'ARRAY', "pathify_as_array_ref() returned array reference");

    $exp_fields = [
        "path",
        "vertical",
        "currency_code",
        "wholesale_price",
        "retail_price",
        "is_actionable",
    ];
    is_deeply($rv->[0], $exp_fields, "Got expected columns");
    $expect = 1;
    for my $i (1 .. $#{$rv}) {
        if (reftype($rv->[$i]->[0]) ne 'ARRAY') {
            $expect = 0;
            last;
        }
    }
    ok($expect, "Each data record has array ref in first column");

    my $path_obj = Parse::File::Taxonomy::Path->new( {
        components => {
            fields          => $path_fields,
            data_records    => $path_data_records,
        },
    } );
    ok(defined $path_obj, "new() returned defined value");
    isa_ok($path_obj, 'Parse::File::Taxonomy::Path');
    my $path_fadrpc = $path_obj->fields_and_data_records_path_components;
    is_deeply($path_fadrpc, $rv,
        "taxonomy-by-index and taxonomy-by-path are equivalent");
}

{
    note("'components' interface; user-supplied column names");
    $exp_fields = ["my_id","my_parent_id","my_name","vertical","currency_code","wholesale_price","retail_price","is_actionable"];
    $exp_data_records = [
        ["1","","Alpha","Auto","USD","","","0"],
        ["3","1","Epsilon","Auto","USD","","","0"],
        ["4","3","Kappa","Auto","USD","0.50","0.60","1"],
        ["5","1","Zeta","Auto","USD","","","0"],
        ["6","5","Lambda","Auto","USD","0.40","0.50","1"],
        ["7","5","Mu","Auto","USD","0.40","0.50","0"],
        ["2","","Beta","Electronics","JPY","","","0"],
        ["8","2","Eta","Electronics","JPY","0.35","0.45","1"],
        ["9","2","Theta","Electronics","JPY","0.35","0.45","1"],
        ["10","","Gamma","Travel","EUR","","","0"],
        ["11","10","Iota","Travel","EUR","","","0"],
        ["12","11","Nu","Travel","EUR","0.60","0.75","1"],
        ["13","","Delta","Life Insurance","USD","0.25","0.30","1"],
    ];
    $obj = Parse::File::Taxonomy::Index->new( {
        components => {
            fields => $exp_fields,
            data_records => $exp_data_records,
        },
        id_col              => 'my_id',
        parent_id_col       => 'my_parent_id',
        component_col       => 'my_name',
    } );
    ok(defined $obj, "new() returned defined value");
    isa_ok($obj, 'Parse::File::Taxonomy::Index');

    is_deeply($obj->fields, $exp_fields, "Got expected columns");
    is_deeply($obj->data_records, $exp_data_records, "Got expected data records");
    $expect = [
        $exp_fields,
        @{$exp_data_records},
    ];
    is_deeply($obj->fields_and_data_records, $expect, "Got expected fields and data records");

    $expect = 0;
    is($obj->id_col_idx, $expect, "Got expected index of 'id' column");
    $expect = 'my_id';
    is($obj->id_col, $expect, "Got expected name of 'id' column");
    $expect = 1;
    is($obj->parent_id_col_idx, $expect, "Got expected index of 'parent_id' column");
    $expect = 'my_parent_id';
    is($obj->parent_id_col, $expect, "Got expected name of 'parent_id' column");
    $expect = 2;
    is($obj->component_col_idx, $expect, "Got expected index of 'component' column");
    $expect = 'my_name';
    is($obj->component_col, $expect, "Got expected name of 'component' column");

    my $rv = $obj->pathify_as_array_ref;
    ok($rv, "pathify_as_array_ref() returned true value");
    ok(ref($rv), "pathify_as_array_ref() returned reference");
    is(reftype($rv), 'ARRAY', "pathify_as_array_ref() returned array reference");

    $exp_fields = [
        "path",
        "vertical",
        "currency_code",
        "wholesale_price",
        "retail_price",
        "is_actionable",
    ];
    is_deeply($rv->[0], $exp_fields, "Got expected columns");
    $expect = 1;
    for my $i (1 .. $#{$rv}) {
        if (reftype($rv->[$i]->[0]) ne 'ARRAY') {
            $expect = 0;
            last;
        }
    }
    ok($expect, "Each data record has array ref in first column");

    my $path_obj = Parse::File::Taxonomy::Path->new( {
        components => {
            fields          => $path_fields,
            data_records    => $path_data_records,
        },
    } );
    ok(defined $path_obj, "new() returned defined value");
    isa_ok($path_obj, 'Parse::File::Taxonomy::Path');
    my $path_fadrpc = $path_obj->fields_and_data_records_path_components;
    is_deeply($path_fadrpc, $rv,
        "taxonomy-by-index and taxonomy-by-path are equivalent");
}

