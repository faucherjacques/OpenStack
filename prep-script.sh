yum install nano ntpdate -y
systemctl stop postfix firewalld NetworkManager
systemctl disable postfix firewalld NetworkManager
systemctl mask NetworkManager
yum remove postfix NetworkManager NetworkManager-libnm -y
setenforce 0
getenforce
cp /etc/selinux/config selinux.bk
sed s/=enforcing/=disabled/ <selinux.bk >/etc/selinux/config
yum install https://www.rdoproject.org/repos/rdo-release.rpm -y
yum install -y centos-release-openstack-ocata
yum update -y
yum install  openstack-packstack -y
cp /etc/default/grub grub.bk
sed 's/rhgb/biosdevname=0 net.ifnames=0 rhgb/' <grub.bk >/etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
# Interface renaming, optional.
eth0hw=$(ip a show dev enp5s0f0 | grep link/ether | cut -c 16-32)
eth1hw=$(ip a show dev enp5s0f1 | grep link/ether | cut -c 16-32)
eth2hw=$(ip a show dev enp2s0f0 | grep link/ether | cut -c 16-32)
eth3hw=$(ip a show dev enp2s0f1 | grep link/ether | cut -c 16-32)
echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="'$eth0hw'", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"' > /etc/udev/rules.d/70-persistent-net.rules
echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="'$eth1hw'", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"' >> /etc/udev/rules.d/70-persistent-net.rules
echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="'$eth2hw'", ATTR{type}=="1", KERNEL=="eth*", NAME="eth2"' >> /etc/udev/rules.d/70-persistent-net.rules
echo 'SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="'$eth3hw'", ATTR{type}=="1", KERNEL=="eth*", NAME="eth3"' >> /etc/udev/rules.d/70-persistent-net.rules
cp /etc/sysconfig/network-scripts/ifcfg-enp5s0f0 /etc/sysconfig/network-scripts/ifcfg-eth0
cp /etc/sysconfig/network-scripts/ifcfg-enp5s0f1 /etc/sysconfig/network-scripts/ifcfg-eth1
cp /etc/sysconfig/network-scripts/ifcfg-enp2s0f0 /etc/sysconfig/network-scripts/ifcfg-eth2
cp /etc/sysconfig/network-scripts/ifcfg-enp2s0f1 /etc/sysconfig/network-scripts/ifcfg-eth3
sed -i s/enp5s0f0/eth0/ /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i s/enp5s0f1/eth1/ /etc/sysconfig/network-scripts/ifcfg-eth1
sed -i s/enp2s0f0/eth2/ /etc/sysconfig/network-scripts/ifcfg-eth2
sed -i s/enp2s0f1/eth3/ /etc/sysconfig/network-scripts/ifcfg-eth3
# End of interface renaming
echo "+-------------+"
echo "|  All done!  |"
echo "+-------------+"
