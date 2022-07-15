echo "Rinobot Ubuntu 18.04 LTS development Setup" 

# echo "blacklist pcspkr" > /etc/modprobe.d/pcspkr.conf
if [[ $EUID -eq 0 ]]; then 
   echo "This script must not be run as root" 1>&2 
   exit 1 
fi 

# disabling bell
echo "set bell-style none" | sudo tee -a /etc/inputrc 
    # appends "set bell-style none" to /etc/inputrc
# case insensitive tab completion
echo "set completion-ignore-case on" | sudo tee -a /etc/inputrc 

sudo apt update && sudo apt upgrade

echo ""
echo "---- setting up CodeRelease ----"
mkdir -p ~/dev/rinobot/CodeRelease
cd ~/dev/rinobot/CodeRelease
sudo apt install git curl python-setuptools
git clone https://github.com/Abrolhus/Mari
cd Mari
mkdir sdk
curl -o sdk/ctc-linux64-atom-2.1.4.13.zip https://media.githubusercontent.com/media/AlexanderSilvaB/Mari-Assets/master/sdk/ctc-linux64-atom-2.1.4.13.zip
./setup


echo ""
echo "---- Setting up OpenCV 2.4.7 ----"
mkdir -p ~/dev/rinobot
cd ~/dev/rinobot
mkdir Core 
cd Core
echo ${pwd}
sudo apt install -y python unzip
sudo apt-get install -y cmake libnss-mdns avahi-discover avahi-utils sshpass unzip python2.7 python-pip cowsay
sudo apt autoremove libopencv-dev python-opencv
git clone https://github.com/Abrolhus/OpenCV-2.4.13
sudo apt install -y g++-4.8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 10
g++ --version
cd OpenCV-2.4.13/
chmod +x compileOpencv_Ubuntu18.py
python compileOpencv_Ubuntu18.py
echo "export OpenCV_DIR="$(echo "$(pwd)/opencv/opencv-2.4.13/release")"" >> ~/.bashrc
source "~/.bashrc"
echo "/usr/local/lib" | sudo tee -a /etc/ld.so.conf
sudo ldconfig
echo "OpenCV 2.4.13 ready to be used"

#wait for user input
# read foobar

echo ""
echo "Setting up Local Toolchain"
cd ~/dev/rinobot/CodeRelease/Mari/
curl -o sdk/naoqi-sdk-2.1.4.13-linux64.tar.gz  https://community-static.aldebaran.com/resources/2.1.4.13/sdk-c%2B%2B/naoqi-sdk-2.1.4.13-linux64.tar.gz
./setup --local
cd ~/dev/rinobot/CodeRelease/Mari/sdk
echo "Fixing OpenCV Files in naoqi-sdk"
# curl -o cv.tar.gz https://raw.githubusercontent.com/Abrolhus/OpenCV-2.4.13/master/samples/naoqi/sdk/cv.tar.gz
# tar -vzxf cv.tar.gz
# cp -r cv/include/ cv/lib/ naoqi-sdk-2.1.4.13-linux64/
cp -r ~/dev/rinobot/Core/OpenCV-2.4.13/opencv/opencv-2.4.13/release/install/include/opencv-2.4.13/*/ naoqi-sdk-2.1.4.13-linux64/include/
cp -r ~/dev/rinobot/Core/OpenCV-2.4.13/opencv/opencv-2.4.13/release/install/lib/ naoqi-sdk-2.1.4.13-linux64/
ln -s /usr/lib/x86_64-linux-gnu/libz.so ~/dev/rinobot/CodeRelease/Mari/sdk/naoqi-sdk-2.1.4.13-linux64/lib/libz.so

# echo ""
# echo "Testing OpenCV installation..."
# cd ~/Development/Rinobot/Core/OpenCV-2.4.13/samples/examples
# mkdir build && cd build
# cmake ..
# make 
# ./image ../lena.jpg
# echo "Diga olá para a Lena, você está com o OpenCV 2.4.13 instalado e funcionando"

