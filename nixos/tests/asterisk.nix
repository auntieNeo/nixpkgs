import ./make-test.nix ({ pkgs, ... }:

{
  name = "asterisk";

  nodes = {
    server = { config, lib, pkgs, ... }:
    {
      virtualisation.diskSize = 4096;

      environment.systemPackages = [
        pkgs.asterisk-testsuite
        pkgs.gdb
        pkgs.screen
      ];

      services.asterisk = {
#        enable = true;
        confFiles = {
          "extensions.conf" = ''
            [tests]
            exten => 101,1,Answer()
            same  =>     n,Echo()
            same  =>     n,Hangup()

            exten => 100,1,Answer()
            same  =>     n,Wait(1)
            same  =>     n,Playback(hello-world)
            same  =>     n,Hangup()
          '';
          "sip.conf" = ''
            [general]
            context=unauthenticated
            allowguest=no
            srvlookup=no  ; Don't do DNS lookup
            udpbindaddr=0.0.0.0  ; Listen on all interfaces
            tcpenable=no
            nat=force_rport,comedia  ; Assume device is behind NAT
            callcounter=yes
            insecure=port,invite

            [softphone](!)
            type=friend  ; Channel driver matches on username first, IP second
            context=softphones
            host=dynamic  ; Device will register with asterisk
            disallow=all
            allow=g722
            allow=ulaw
            allow=alaw

            [sipp](softphone)
            defaultuser=sipp
            host=127.0.0.1
            secret=CytMyQuog2
          '';
        };
      };
    };
  };

  testScript =
    let
      asteriskUser = "asterisk";
      varlibdir = "/var/lib/asterisk";
      spooldir = "/var/spool/asterisk";
      logdir = "/var/log/asterisk";
    in
    ''
#    $server->waitForUnit("asterisk");
#    $server->succeed("kill -0 $(cat /var/run/asterisk/asterisk.pid)");
    $server->waitForUnit("network.target");
#    $server->succeed("asttest-wrapped");

    # Clean up temporary files (probably not needed)
    $server->succeed("bash -c 'rm -rf /tmp/asterisk*'");

    # Copy the skeleton of the /var/lib/asterisk tree.
    # Ordinarily, this is done in the systemd unit that starts Asterisk, but
    # we need to do it here since asterisk-testsuite doesn't use systemd to
    # run Asterisk.
    $server->execute(
        'for d in "${varlibdir}" "${spooldir}" "${logdir}"; do'.
        '  if [ ! -e "$d" ]; then'.
        '    mkdir -p $(dirname "$d");'.
        '    cp -r ${pkgs.asterisk}/"$d" "$d";'.
        '    chown -R ${asteriskUser} "$d";'.
        '    find "$d" -type d | xargs chmod 0755;'.
        '  fi;'.
        'done'
    );
    print $server->succeed("asterisk-runtests.py -g confbridge");
    $server->shutdown;
  '';
})
