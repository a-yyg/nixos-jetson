let
  agx = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECV3m0iKwrH44enXBDjGLOJ5LqC2rP0wK0mT1YrLLca";
in
{
  "tailscale.age".publicKeys = [ agx ];
}
