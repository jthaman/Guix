;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (nongnu packages linux)
             (gnu packages xorg)
             (gnu system nss)
             (gnu services vpn)
             (gnu services desktop)
             (nongnu system linux-initrd)
             (gnu services pm))         ; TLP

(use-service-modules cups desktop networking ssh xorg vpn)
(use-package-modules suckless wm)

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (locale "en_US.utf8")
 (timezone "America/New_York")
 (keyboard-layout (keyboard-layout "us" "dvorak"))
 (host-name "t460")

 ;; The list of user accounts ('root' is implicit).
 (users (cons* (user-account
                (name "john")
                (comment "John Haman")
                (group "users")
                (home-directory "/home/john")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

 ;; Packages installed system-wide.
 (packages  (append (list
                     xmonad
                     dmenu
                     xterm)
                    %base-packages))

 ;; Services
 (services
  (append
   (list
    (service gnome-desktop-service-type)
    (set-xorg-configuration
     (xorg-configuration
      (keyboard-layout keyboard-layout)))
    (service cups-service-type)
    (service tlp-service-type
             (tlp-configuration
              (cpu-scaling-governor-on-ac (list "performance"))
              (sched-powersave-on-bat? #t))))
    ;; Common desktop services (dbus, udisks, networking, polkit, etc.)
   %desktop-services))

 ;; Bootloader
 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (targets (list "/dev/sda"))
              (keyboard-layout keyboard-layout)))

 ;; Swap devices
 (swap-devices
  (list (swap-space
         (target (uuid "70cb259e-006d-4e69-9f0a-b481e454e083")))))

 ;; File systems
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device (uuid
                   "2cf56af4-6760-4833-aec7-d39565cfbcd7" 'ext4))
          (type "ext4"))
         %base-file-systems)))
