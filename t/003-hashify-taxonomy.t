# perl
# t/003-hashify-taxonomy.t
use strict;
use warnings;
use Carp;
use utf8;

use lib ('./lib');
use Parse::File::Taxonomy;
use Test::More tests => 12;

my ($obj, $source, $expect, $hashified);

{
    $source = "./t/data/beta.csv";
    $obj = Parse::File::Taxonomy->new( {
        file    => $source,
    } );
    ok(defined $obj, "'new()' returned defined value");
    isa_ok($obj, 'Parse::File::Taxonomy');

    local $@;
    eval {
        $hashified = $obj->hashify_taxonomy(
            key_delim => q{ - },
        );
    };
    like($@, qr/^Argument to 'new\(\)' must be hashref/,
        "'hashify_taxonomy()' died to lack of hashref as argument; was just a key-value pair");

    local $@;
    eval {
        $hashified = $obj->hashify_taxonomy( [
            key_delim => q{ - },
        ] );
    };
    like($@, qr/^Argument to 'new\(\)' must be hashref/,
        "'hashify_taxonomy()' died to lack of hashref as argument; was arrayref");
}

{
    $source = "./t/data/beta.csv";
    $obj = Parse::File::Taxonomy->new( {
        file    => $source,
    } );
    ok(defined $obj, "'new()' returned defined value");
    isa_ok($obj, 'Parse::File::Taxonomy');

    $expect = {
        "|Alpha" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "|Alpha|Epsilon" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Epsilon",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "|Alpha|Epsilon|Kappa" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Epsilon|Kappa",
                    retail_price => "0.60",
                    vertical => "Auto",
                    wholesale_price => "0.50",
                  },
        "|Alpha|Zeta" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "|Alpha|Zeta|Lambda" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Zeta|Lambda",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "|Alpha|Zeta|Mu" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta|Mu",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "|Beta" => {
                    currency_code => "JPY",
                    is_actionable => 0,
                    path => "|Beta",
                    retail_price => "",
                    vertical => "Electronics",
                    wholesale_price => "",
                  },
        "|Beta|Eta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Eta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "|Beta|Theta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Theta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "|Gamma" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "|Gamma|Iota" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma|Iota",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "|Gamma|Iota|Nu" => {
                    currency_code => "EUR",
                    is_actionable => 1,
                    path => "|Gamma|Iota|Nu",
                    retail_price => 0.75,
                    vertical => "Travel",
                    wholesale_price => "0.60",
                  },
        "|Delta" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Delta",
                    retail_price => "0.30",
                    vertical => "Life Insurance",
                    wholesale_price => 0.25,
                  },
    };
    $hashified = $obj->hashify_taxonomy();
    is_deeply($hashified, $expect, "Got expected hashified taxonomy (no args)");

    $expect = {
        "Alpha" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "Alpha|Epsilon" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Epsilon",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "Alpha|Epsilon|Kappa" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Epsilon|Kappa",
                    retail_price => "0.60",
                    vertical => "Auto",
                    wholesale_price => "0.50",
                  },
        "Alpha|Zeta" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "Alpha|Zeta|Lambda" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Zeta|Lambda",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "Alpha|Zeta|Mu" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta|Mu",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "Beta" => {
                    currency_code => "JPY",
                    is_actionable => 0,
                    path => "|Beta",
                    retail_price => "",
                    vertical => "Electronics",
                    wholesale_price => "",
                  },
        "Beta|Eta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Eta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "Beta|Theta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Theta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "Gamma" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "Gamma|Iota" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma|Iota",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "Gamma|Iota|Nu" => {
                    currency_code => "EUR",
                    is_actionable => 1,
                    path => "|Gamma|Iota|Nu",
                    retail_price => 0.75,
                    vertical => "Travel",
                    wholesale_price => "0.60",
                  },
        "Delta" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Delta",
                    retail_price => "0.30",
                    vertical => "Life Insurance",
                    wholesale_price => 0.25,
                  },
    };
    $hashified = $obj->hashify_taxonomy( {
        remove_leading_path_col_sep => 1,
    } );
    is_deeply($hashified, $expect,
        "Got expected hashified taxonomy (remove_leading_path_col_sep)");

    $expect = {
        "/Alpha" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "/Alpha/Epsilon" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Epsilon",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "/Alpha/Epsilon/Kappa" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Epsilon|Kappa",
                    retail_price => "0.60",
                    vertical => "Auto",
                    wholesale_price => "0.50",
                  },
        "/Alpha/Zeta" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "/Alpha/Zeta/Lambda" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Zeta|Lambda",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "/Alpha/Zeta/Mu" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta|Mu",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "/Beta" => {
                    currency_code => "JPY",
                    is_actionable => 0,
                    path => "|Beta",
                    retail_price => "",
                    vertical => "Electronics",
                    wholesale_price => "",
                  },
        "/Beta/Eta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Eta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "/Beta/Theta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Theta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "/Gamma" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "/Gamma/Iota" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma|Iota",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "/Gamma/Iota/Nu" => {
                    currency_code => "EUR",
                    is_actionable => 1,
                    path => "|Gamma|Iota|Nu",
                    retail_price => 0.75,
                    vertical => "Travel",
                    wholesale_price => "0.60",
                  },
        "/Delta" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Delta",
                    retail_price => "0.30",
                    vertical => "Life Insurance",
                    wholesale_price => 0.25,
                  },
    };
    $hashified = $obj->hashify_taxonomy( {
        key_delim => '/',
    } );
    is_deeply($hashified, $expect, "Got expected hashified taxonomy (key_delim)");

    $expect = {
        "Alpha" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "Alpha - Epsilon" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Epsilon",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "Alpha - Epsilon - Kappa" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Epsilon|Kappa",
                    retail_price => "0.60",
                    vertical => "Auto",
                    wholesale_price => "0.50",
                  },
        "Alpha - Zeta" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "Alpha - Zeta - Lambda" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Zeta|Lambda",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "Alpha - Zeta - Mu" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta|Mu",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "Beta" => {
                    currency_code => "JPY",
                    is_actionable => 0,
                    path => "|Beta",
                    retail_price => "",
                    vertical => "Electronics",
                    wholesale_price => "",
                  },
        "Beta - Eta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Eta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "Beta - Theta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Theta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "Gamma" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "Gamma - Iota" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma|Iota",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "Gamma - Iota - Nu" => {
                    currency_code => "EUR",
                    is_actionable => 1,
                    path => "|Gamma|Iota|Nu",
                    retail_price => 0.75,
                    vertical => "Travel",
                    wholesale_price => "0.60",
                  },
        "Delta" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Delta",
                    retail_price => "0.30",
                    vertical => "Life Insurance",
                    wholesale_price => 0.25,
                  },
    };
    $hashified = $obj->hashify_taxonomy( {
        remove_leading_path_col_sep => 1,
        key_delim => q{ - },
    } );
    is_deeply($hashified, $expect,
        "Got expected taxonomy (remove_leading_path_col_sep and key_delim)");

    $expect = {
        "All Suppliers|Alpha" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "All Suppliers|Alpha|Epsilon" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Epsilon",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "All Suppliers|Alpha|Epsilon|Kappa" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Epsilon|Kappa",
                    retail_price => "0.60",
                    vertical => "Auto",
                    wholesale_price => "0.50",
                  },
        "All Suppliers|Alpha|Zeta" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "All Suppliers|Alpha|Zeta|Lambda" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Zeta|Lambda",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "All Suppliers|Alpha|Zeta|Mu" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta|Mu",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "All Suppliers|Beta" => {
                    currency_code => "JPY",
                    is_actionable => 0,
                    path => "|Beta",
                    retail_price => "",
                    vertical => "Electronics",
                    wholesale_price => "",
                  },
        "All Suppliers|Beta|Eta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Eta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "All Suppliers|Beta|Theta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Theta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "All Suppliers|Gamma" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "All Suppliers|Gamma|Iota" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma|Iota",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "All Suppliers|Gamma|Iota|Nu" => {
                    currency_code => "EUR",
                    is_actionable => 1,
                    path => "|Gamma|Iota|Nu",
                    retail_price => 0.75,
                    vertical => "Travel",
                    wholesale_price => "0.60",
                  },
        "All Suppliers|Delta" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Delta",
                    retail_price => "0.30",
                    vertical => "Life Insurance",
                    wholesale_price => 0.25,
                  },
    };
    $hashified = $obj->hashify_taxonomy( {
        root_str => 'All Suppliers',
    } );
    is_deeply($hashified, $expect,
        "Got expected taxonomy (root_str)");

    $expect = {
        "All Suppliers - Alpha" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "All Suppliers - Alpha - Epsilon" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Epsilon",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "All Suppliers - Alpha - Epsilon - Kappa" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Epsilon|Kappa",
                    retail_price => "0.60",
                    vertical => "Auto",
                    wholesale_price => "0.50",
                  },
        "All Suppliers - Alpha - Zeta" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta",
                    retail_price => "",
                    vertical => "Auto",
                    wholesale_price => "",
                  },
        "All Suppliers - Alpha - Zeta - Lambda" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Alpha|Zeta|Lambda",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "All Suppliers - Alpha - Zeta - Mu" => {
                    currency_code => "USD",
                    is_actionable => 0,
                    path => "|Alpha|Zeta|Mu",
                    retail_price => "0.50",
                    vertical => "Auto",
                    wholesale_price => "0.40",
                  },
        "All Suppliers - Beta" => {
                    currency_code => "JPY",
                    is_actionable => 0,
                    path => "|Beta",
                    retail_price => "",
                    vertical => "Electronics",
                    wholesale_price => "",
                  },
        "All Suppliers - Beta - Eta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Eta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "All Suppliers - Beta - Theta" => {
                    currency_code => "JPY",
                    is_actionable => 1,
                    path => "|Beta|Theta",
                    retail_price => 0.45,
                    vertical => "Electronics",
                    wholesale_price => 0.35,
                  },
        "All Suppliers - Gamma" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "All Suppliers - Gamma - Iota" => {
                    currency_code => "EUR",
                    is_actionable => 0,
                    path => "|Gamma|Iota",
                    retail_price => "",
                    vertical => "Travel",
                    wholesale_price => "",
                  },
        "All Suppliers - Gamma - Iota - Nu" => {
                    currency_code => "EUR",
                    is_actionable => 1,
                    path => "|Gamma|Iota|Nu",
                    retail_price => 0.75,
                    vertical => "Travel",
                    wholesale_price => "0.60",
                  },
        "All Suppliers - Delta" => {
                    currency_code => "USD",
                    is_actionable => 1,
                    path => "|Delta",
                    retail_price => "0.30",
                    vertical => "Life Insurance",
                    wholesale_price => 0.25,
                  },
    };
    $hashified = $obj->hashify_taxonomy( {
        key_delim => ' - ',
        root_str => 'All Suppliers',
    } );
    is_deeply($hashified, $expect, "Got expected taxonomy (key_delim and root_str)");
}

