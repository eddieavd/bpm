#!/bin/zsh

if [[ $# -lt 1 ]]; then
        echo "\nusage: ./create_env.sh [ -e example_to_run ] [ -h protocol (http/https) ] [ -p port_num ] { blinkid_version }"
        echo "\navailable examples:\tblinkid-camera\n\t\t\tblinkid-file\n\t\t\tidbarcode\n\t\t\tmulti-side-file\n\t\t\tmulti-side"
        exit 1
fi

example="blinkid-camera"
portnum="4443"
protocol="http"
bid_ver="v6.0.1"

while getopts e:p:h: flag
do
        case "${flag}" in
                e) example=${OPTARG};;
                p) portnum=${OPTARG};;
                h) protocol=${OPTARG};;
        esac
done

bid_ver=${@: -1}

echo "Creating environment for BlinkID $bid_ver $example example on port $portnum...\n"

rm -rf demoapp
mkdir demoapp

if [ "$protocol" = "https" ]; then
        echo "Getting local IP..."
        # some hacky dumb stuff ahead
        localips=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
        NL='
'
        localip=${localips%%"$NL"*}
        echo "Local IP is: $localip\n"

        echo "Creating certificate..."
        cd demoapp
        mkdir cert && cd cert
        mkcert $localip
        mv *key* ip_key.pem
        mv $localip* ip.pem
        cd ../..
        echo "Certificate created!\n"
else
        localip="localhost"
fi

echo "Cloning BlinkID In-browser SDK $bid_ver"
git clone --depth 1 --branch $bid_ver git@github.com:blinkid/blinkid-in-browser /tmp/create_env_bid_repo_$bid_ver
echo "Repo cloned!\n"

echo "Setting up demo app..."
cp -rf /tmp/create_env_bid_repo_$bid_ver/examples/$example/javascript/* demoapp
cp -rf /tmp/create_env_bid_repo_$bid_ver/resources demoapp

if [ "$protocol" = "https" ]; then
        awk -v d="\"https://$localip\:$portnum/resources\"" '$1=="loadSettings.engineLocation"{$3=d} 1' demoapp/app.js > demoapp/tmpapp.js
        mv demoapp/tmpapp.js demoapp/app.js
else
        awk -v d="\"http://$localip\:$portnum/resources\"" '$1=="loadSettings.engineLocation"{$3=d} 1' demoapp/app.js > demoapp/tmpapp.js
        mv demoapp/tmpapp.js demoapp/app.js
fi

awk '!/loadSettings.workerLocation/' demoapp/app.js > demoapp/tmpapp.js
mv demoapp/tmpapp.js demoapp/app.js
echo "Demo app set up!\n"

echo "Removing temporary files...\n"
rm -rf /tmp/create_env_bid_repo_$bid_ver

echo "Launching server..."
if [ "$protocol" = "https" ]; then
        cp ssl_server.sh demoapp/serve.sh
#        cd demoapp && chmod +x serve.sh && ./serve.sh $localip $portnum
else
        echo "python3 -m http.server $portnum" > demoapp/serve.sh
#        cd demoapp && chmod +x serve.sh && ./serve.sh
fi

echo "Access the app at $localip : $portnum\n"
cd demoapp && chmod +x serve.sh && ./serve.sh $localip $portnum
