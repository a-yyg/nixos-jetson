let
  xavier = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECV3m0iKwrH44enXBDjGLOJ5LqC2rP0wK0mT1YrLLca";
  orin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnXkWcgkOrL7b40pD9ejZcY8uM739funXD7nWtLOc3y";
in
{
  "tailscale.age".publicKeys = [ xavier ];
  "cachix-xavier.age".publicKeys = [ xavier ];
  "cachix-orin.age".publicKeys = [ orin ];
}
