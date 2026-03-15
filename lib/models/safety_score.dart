class SafetyScore {

  /// Calculates safety score based on:
  /// - CCTV count
  /// - Police station count
  /// - Hospital count
  /// - Street light count
  ///
  /// Returns score between 0 and 100
  static int calculate({
    required int cctv,
    required int police,
    required int hospital,
    required int streetLight,
  }) {

    // 🔐 Weightage (adjustable)
    const int cctvWeight = 4;
    const int policeWeight = 25;
    const int hospitalWeight = 10;
    const int streetLightWeight = 3;

    int score = 0;

    score += cctv * cctvWeight;
    score += police * policeWeight;
    score += hospital * hospitalWeight;
    score += streetLight * streetLightWeight;

    // 🎯 Cap maximum score at 100
    if (score > 100) {
      score = 100;
    }

    return score;
  }
}