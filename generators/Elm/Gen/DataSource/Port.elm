module Elm.Gen.DataSource.Port exposing (get, id_, make_, moduleName_, types_)

{-| 
-}


import Elm
import Elm.Annotation as Type


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "DataSource", "Port" ]


types_ : {}
types_ =
    {}


make_ : {}
make_ =
    {}


{-| In a vanilla Elm application, ports let you either send or receive JSON data between your Elm application and the JavaScript context in the user's browser at runtime.

With `DataSource.Port`, you send and receive JSON to JavaScript running in NodeJS during build-time. This means that you can call shell scripts, or run NPM packages that are installed, or anything else you could do with NodeJS.

A `DataSource.Port` will call an async JavaScript function with the given name. The function receives the input JSON value, and the Decoder is used to decode the return value of the async function.

Here is the Elm code and corresponding JavaScript definition for getting an environment variable (or a build error if it isn't found).

    import DataSource exposing (DataSource)
    import DataSource.Port
    import Json.Encode
    import OptimizedDecoder as Decode

    data : DataSource String
    data =
        DataSource.Port.get "environmentVariable"
            (Json.Encode.string "EDITOR")
            Decode.string

    -- will resolve to "VIM" if you run `EDITOR=vim elm-pages dev`

```javascript
const kleur = require("kleur");


module.exports =
  /**
   * @param { unknown } fromElm
   * @returns { Promise<unknown> }
   */
  {
    environmentVariable: async function (name) {
      const result = process.env[name];
      if (result) {
        return result;
      } else {
        throw `No environment variable called ${kleur
          .yellow()
          .underline(name)}\n\nAvailable:\n\n${Object.keys(process.env).join(
          "\n"
        )}`;
      }
    },
  }
```


## Error Handling

`port-data-source.js`

Any time you throw an exception from a DataaSource.Port definition, it will result in a build error in your `elm-pages build` or dev server. In the example above, if the environment variable
is not found it will result in a build failure. Notice that the NPM package `kleur` is being used in this example to add color to the output for that build error. You can use any tool you
prefer to add ANSI color codes within the error string in an exception and it will show up with color output in the build output and dev server.


## Performance

As with any JavaScript or NodeJS code, avoid doing blocking IO operations. For example, avoid using `fs.readFileSync`, because blocking IO can slow down your elm-pages builds and dev server.

-}
get : Elm.Expression -> Elm.Expression -> Elm.Expression -> Elm.Expression
get arg1 arg2 arg3 =
    Elm.apply
        (Elm.valueWith
            moduleName_
            "get"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Json", "Encode" ] "Value" []
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
        )
        [ arg1, arg2, arg3 ]


{-| Every value/function in this module in case you need to refer to it directly. -}
id_ : { get : Elm.Expression }
id_ =
    { get =
        Elm.valueWith
            moduleName_
            "get"
            (Type.function
                [ Type.string
                , Type.namedWith [ "Json", "Encode" ] "Value" []
                , Type.namedWith
                    [ "OptimizedDecoder" ]
                    "Decoder"
                    [ Type.var "b" ]
                ]
                (Type.namedWith [ "DataSource" ] "DataSource" [ Type.var "b" ])
            )
    }


