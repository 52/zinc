{ inputs, ... }:
{
  relativeToRoot = path: "${inputs.self}/${path}";
}
