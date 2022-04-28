Adobe Connect does not have a native Linux client and its web app does not allow you to share your screen in a webinar.
You could use Wine (vanilla wine or a wrapper like lutris, bottles, playonlinux, and etc.) to install the native client and share your screen that way, but that's just way too much of a hassle.

Here are two ways that I managed to share my screen on Adobe Connect:

## Virtual Camera
The web app allows you to share your webcam; Here's how you can use this feature to share your screen on the web app using a virtual camera.

1\. Install [OBS Studio](https://obsproject.com/). I highly recommend installing it via the official [Flatpak](https://flathub.org/apps/details/com.obsproject.Studio) package, mainly because the binaries provided by various distributions are sometimes compiled with certain features turned off and are not always up to date.

2\. Since version [26.1](https://github.com/obsproject/obs-studio/releases/tag/26.1.0) OBS supports built-in Virtual Camera output on Linux. In order to use it, you have to install the [v4l2loopback](https://github.com/umlaeute/v4l2loopback) module. (depending on your distribution you may want to use [DKMS](https://wiki.archlinux.org/title/Dynamic_Kernel_Module_Support)). You need to find out how you can install this module for your distribution (you can also build it yourself).
This could be as simple as:

{% highlight shell %}
sudo pacman -Syu v4l2loopback-dkms
{% endhighlight %}
for Arch-based distros,

{% highlight shell %}
sudo apt install -y v4l2loopback-dkms
{% endhighlight %}
for debian-based distros, or 

{% highlight nix %}
boot.kernelModules = [ "v4l2loopback" ];
boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
{% endhighlight %}
for NixOS.

After the installation, you need to make sure that the `v4l2loopback` module is loaded.

3\. Now open OBS Studios. You should see a `Start Virtual Camera` button. If you don't see such a button, open OBS using a terminal, read the log messages, and diagnose why OBS can't enable its virtual camera functionality.

{:style="text-align:center;"}
![OBS Virtual Camera](/assets/2022-04-28-adobe-connect-screen-sharing-on-linux/01-virt-cam-button.jpg)

4\. Create a `Scene` and add a `Screen Capture` source to it. Then, start the virtual camera. 

5\. Join a webinar using a browser (I use `Firefox`. Some people have reported that their virtual cameras don't show up on chromium-based browsers).
Either get the host to make you a host as well or ask them to do the following:
- Go to `Preferences -> Video` and change the aspect ratio to `16:9`.

{:style="text-align:center;"}
![Aspect Ratio](/assets/2022-04-28-adobe-connect-screen-sharing-on-linux/02-preferences-aspect-ratio.jpg)

- Create a new layout and add your desired pods to it along with a large video pod. 

{:style="text-align:center;"}
![Layout](/assets/2022-04-28-adobe-connect-screen-sharing-on-linux/03-video-layout.jpg)

6\. Click on the webcam button and allow the site to use your virtual camera.

{:style="text-align:center;"}
![webcam](/assets/2022-04-28-adobe-connect-screen-sharing-on-linux/04-select-webcam.jpg)

7\. Click on `Start Sharing` to share your screen.

{:style="text-align:center;"}
![share](/assets/2022-04-28-adobe-connect-screen-sharing-on-linux/05-start-share.jpg)

> You can control the output resolution of OBS in its settings. Turning down the resolution may help reduce the needed bandwidth to stream your desktop.

## Virtual Machine
You can use a Windows virtual machine to share your Linux desktop. This is a little bit more involved and requires more resources.
Here is the basic idea:

1\. Create a Windows guest VM
I use libvirt managed by virt-manager.

2\. Install Adobe Connect in the VM

3\. Install a remote desktop sharing client in the VM (e.g. VNC Client, TigerVNC)

4\. Make sure there is network connectivity between the guest VM and host (the default NAT is okay)
You need the IP address of the host machine in the virtual network. You can do a simple
{% highlight bash %}
ip a
{% endhighlight %}
on the host machine to find the IP address of the interface connected to the virtual network.

5\. Install a remote desktop sharing server in the host (e.g. VNC Server, TigerVNC)
I use TigerVNC. First, create a password using `vncpasswd` and then run 
{% highlight bash %}
x0vncserver -PasswordFile=.vnc/passwd
{% endhighlight %}
to start a VNC server connected directly to your running x-server without creating a virtual desktop.

Now you can share the screen of your Windows guest in a webinar and connect to the VNC server on the host machine using its IP address in the virtual network and share the screen of your Linux machine through the Windows VM.
