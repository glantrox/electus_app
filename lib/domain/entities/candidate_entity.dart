import 'package:equatable/equatable.dart';
// Actually, it's better to recreate HollandCodeEntity to be pure domain, but for simplicity let's use a pure representation.

class HollandCodeDistributionEntity extends Equatable {
  final String code;
  final String label;
  final num value;
  final String color;

  const HollandCodeDistributionEntity({
    required this.code,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  List<Object?> get props => [code, label, value, color];
}

class HollandCodeEntity extends Equatable {
  final String primary;
  final String label;
  final List<HollandCodeDistributionEntity>? distribution;

  const HollandCodeEntity({
    required this.primary,
    required this.label,
    this.distribution,
  });

  @override
  List<Object?> get props => [primary, label, distribution];
}

class CandidateEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String reviewStatus;
  final String processingStatus;
  final List<String> aiSummary;
  final String cvText;
  final List<String> skills;
  final HollandCodeEntity? hollandCode;
  final String education;
  final String experience;
  final String portfolioUrl;
  final bool hasPortfolio;
  final num matchScore;
  final String cvFilePath;
  final List<num>? embedding;
  final DateTime? createdAt;

  const CandidateEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.reviewStatus,
    required this.processingStatus,
    required this.aiSummary,
    required this.cvText,
    required this.skills,
    this.hollandCode,
    required this.education,
    required this.experience,
    required this.portfolioUrl,
    required this.hasPortfolio,
    required this.matchScore,
    required this.cvFilePath,
    this.embedding,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        reviewStatus,
        processingStatus,
        aiSummary,
        cvText,
        skills,
        hollandCode,
        education,
        experience,
        portfolioUrl,
        hasPortfolio,
        matchScore,
        cvFilePath,
        embedding,
        createdAt,
      ];
}
