# bpm

A simple utility for launching [BlinkID In-browser SDK](https://github.com/BlinkID/blinkid-in-browser) demo apps.

## creating an app

To create and run a demo app, run:

```bash
$ ./bpm_create <blinkid_version_tag>
```
or for the latest version simply:
```bash
$ ./bpm_create latest
```

The script will create a `demoapp` directory which will contain all the necessary files for running the app. The BlinkID version tags can be found [here](https://github.com/BlinkID/blinkid-in-browser/tags).

### additional arguments

#### -e \<example_to_run\>
Specifies which BlinkID example app will be built. List available [here](https://github.com/BlinkID/blinkid-in-browser/tree/master/examples).
Default is `blinkid-camera`.  
Currently only javascript examples are used.

#### -k \<path_to_keyfile\>
Read license key from a file instead of standard input.

#### -h \<protocol\>
Supported protocols: http, https. Default is `http`.  
Selecting https will automatically create certificates for the local IP in `/demoapp/cert` (assumes [_mkcert_](https://github.com/FiloSottile/mkcert#macos) is installed).

#### -p \<port_number\>
Specifies the port the app will listen on. Default is `8372`.

#### example
```bash
$ ./bpm_create -e blinkid-file -k key.txt -h https -p 4443 v6.0.1
```

## what now?

The `bpm_create` script will start the app automatically upon completion and can be stopped with `CTRL+c`.  
The `demoapp` directory will also contain a `bpm_serve` script which you can run to restart the app.
