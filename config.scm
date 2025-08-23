;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (gnu services pm))         ; TLP

(use-service-modules cups desktop networking ssh xorg)


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
                (supplementary-groups '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages %base-packages)

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (append (list
           (service gnome-desktop-service-type)
           (service cups-service-type)
           (set-xorg-configuration
            (xorg-configuration (keyboard-layout keyboard-layout))))
          %desktop-services))

 ;; Power management (only on thinkpad)

 (service tlp-service-type
          (tlp-configuration
           (cpu-scaling-governor-on-ac (list "performance"))
           (sched-powersave-on-bat? #t)))

 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (targets (list "/dev/sda"))
              (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
                      (target (uuid
                               "70cb259e-006d-4e69-9f0a-b481e454e083")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/")
                       (device (uuid
                                "2cf56af4-6760-4833-aec7-d39565cfbcd7"
                                'ext4))
                       (type "ext4")) %base-file-systems)))
