text
timezone --utc America/Toronto
clearpart --all --initlabel
autopart
reboot

user --name=akdev --groups=wheel --password=placeholder
sshkey --username=akdev "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/+uQuSBwFZecLIXDjTSf1lVMzOsxDjkPk7h5GF8rsn31rWOssyDJyQewjsQ0tIEhsxmQ14x8RNx6kmKKBk0qgO/SlLzjE27bcaq8Y96PftzUftlGhMqN2h3/SDqTaPlB2laGO9oPAwaZRaCj7zXMdZe4mkLSCZXCytGRNyhg36/FdDsal4onAes3diEa+huz1C3PQVKu59Oc2KVZw2Onw3jH/ddBfusIr8SNvi+sPl5TfvEr4ww99IJ3XR1XvQfbHjNnKZ0jU275jzHPX6mRqg0PZJ9tPiwvXIoFG1E/MXKagKZtBfGRkGIQVHx8eux/lTlEYWPh65/aeMgcKj4ra2y3UFdsRPo//WnRNiRRtmTJFNUC1jg8j6qbOhA8bI0OVQsIYQEaY8/f+uRK3+AcPa8OaPOrTSjJ2/9zFibwshYShmLgc/KskXaeMfUpjS5ylWufzNWVsbBY8dpfUtSvss9Ml3VH9mKWEeOm0fCAJH/MoKLBnxUqBA3hd3o3lpXJMIiz8732+SdhxXeHqNXJOYxqJFJmWcwZ2Tz8Kbfb0l42rEu/i0sbzTWOpWFew7k7QP0cNKsNFK5B55R+2UqRxBqBC8K6b936WzbrERznfjb1e8HKly/tKfWilpZsUXtcCkn2x4Sf8NZLbX3wZjXrr3T6tKz9LfdQBsKVcIPCSpw== cardno:12 279 794"

# there's no supported way of getting the GPG keys...
ostreesetup --ref=fedora/35/x86_64/kinoite --url=https://kojipkgs.fedoraproject.org/compose/ostree/repo --osname=kinoite --nogpg


repo --name=rpmfusion-free-release --baseurl=http://download1.rpmfusion.org/free/fedora/releases/35/Everything/x86_64/os/ --install
repo --name=rpmfusion-nonfree-release --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/35/Everything/x86_64/os/ --install

%packages
akmod-nvidia xorg-x11-drv-nvidia-cuda
%end

%post
echo rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1
%end
