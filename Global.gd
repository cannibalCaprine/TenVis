class_name Global

static func basically_zero(val: float, eps: float) -> bool:
	return val > -eps && val < eps
