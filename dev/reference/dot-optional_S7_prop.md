# Get an S7 property if it exists

Get an S7 property if it exists

## Usage

``` r
.optional_S7_prop(obj, prop)
```

## Arguments

- obj:

  (`any`) The S7 object from which the property should be extracted.

- prop:

  (`character`) The name of the property to extract.

## Value

(`any`) The value of the property, if it exists in `obj` (`NULL`
invisibly otherwise).
