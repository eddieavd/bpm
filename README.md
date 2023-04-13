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

The script will create a _demoapp_ directory which will contain all the necessary files for running the app. The BlinkID version tags can be found [here](https://github.com/BlinkID/blinkid-in-browser/tags).

### additional arguments

#### -e \<example_to_run\>
Specifies which BlinkID example app will be built. List available [here](https://github.com/BlinkID/blinkid-in-browser/tree/master/examples).
Default is _blinkid-camera_.  
Currently only javascript examples are used.

#### -k \<path_to_keyfile\>
Read license key from a file instead of standard input.

#### -h \<protocol\>
Supported protocols: http, https. Default is _http_.  
Selecting https will automatically create certificates for the local IP in _/demoapp/cert_ (assumes [_mkcert_](https://github.com/FiloSottile/mkcert#macos) is installed).

#### -p \<port_number\>
Specifies the port the app will listen on. Default is _8372_.

#### example
```bash
$ ./bpm_create -e blinkid-file -k key.txt -h https -p 4443 v6.0.1
```

## what now?

The _bpm_create_ script will start the app automatically upon completion and can be stopped with CTRL+c.  
The _demoapp_ directory will also contain a _bpm_serve_ script which you can run to restart the app.