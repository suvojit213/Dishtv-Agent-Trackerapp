// CSAT Entry Entity
import 'package:equatable/equatable.dart';

class CSATEntry extends Equatable {
  final int? id;
  final DateTime date;
  final int t2Count;
  final int b2Count;
  final int nCount;
  
  const CSATEntry({
    this.id,
    required this.date,
    required this.t2Count,
    required this.b2Count,
    required this.nCount,
  });
  
  // Total survey hits
  int get totalSurveyHits {
    return t2Count + b2Count + nCount;
  }
  
  // Calculate individual scores
  double get nScore {
    if (nCount == 0) return 0.0;
    return (100 / totalSurveyHits) * nCount;
  }
  
  double get b2Score {
    if (b2Count == 0) return 0.0;
    return (100 / totalSurveyHits) * b2Count;
  }
  
  double get t2Score {
    if (t2Count == 0) return 0.0;
    return (100 / totalSurveyHits) * t2Count;
  }
  
  // Calculate CSAT percentage (T2 - B2)
  double get csatPercentage {
    return t2Score - b2Score;
  }
  
  // Check if CSAT needs improvement (below 60%)
  bool get needsImprovement {
    return csatPercentage < 60.0;
  }
  
  // Copy with method for creating a new instance with some updated values
  CSATEntry copyWith({
    int? id,
    DateTime? date,
    int? t2Count,
    int? b2Count,
    int? nCount,
  }) {
    return CSATEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      t2Count: t2Count ?? this.t2Count,
      b2Count: b2Count ?? this.b2Count,
      nCount: nCount ?? this.nCount,
    );
  }
  
  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      't2_count': t2Count,
      'b2_count': b2Count,
      'n_count': nCount,
    };
  }
  
  // Create from Map for database operations
  factory CSATEntry.fromMap(Map<String, dynamic> map) {
    return CSATEntry(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      t2Count: map['t2_count'],
      b2Count: map['b2_count'],
      nCount: map['n_count'],
    );
  }
  
  @override
  List<Object?> get props => [id, date, t2Count, b2Count, nCount];
}

