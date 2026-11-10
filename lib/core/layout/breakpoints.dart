/// Device groups from docs/design-system.md, section 6.1.
enum LayoutClass {
  compact,
  medium,
  expanded,
  large;

  static LayoutClass fromShortestSide(double shortestSide) {
    if (shortestSide >= 800) return large;
    if (shortestSide >= 720) return expanded;
    if (shortestSide >= 600) return medium;
    return compact;
  }
}
