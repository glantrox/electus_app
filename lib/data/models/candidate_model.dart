import 'package:electus_app/domain/entities/candidate_entity.dart';

class HollandCodeDistribution {
  final String code;
  final String label;
  final num value;
  final String color;

  HollandCodeDistribution({
    required this.code,
    required this.label,
    required this.value,
    required this.color,
  });

  factory HollandCodeDistribution.fromJson(Map<String, dynamic> json) {
    return HollandCodeDistribution(
      code: json['code'] ?? '',
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'label': label, 'value': value, 'color': color};
  }

  HollandCodeDistributionEntity toEntity() {
    return HollandCodeDistributionEntity(
      code: code,
      label: label,
      value: value,
      color: color,
    );
  }
}

class HollandCode {
  final String primary;
  final String label;
  final List<HollandCodeDistribution>? distribution;

  HollandCode({required this.primary, required this.label, this.distribution});

  factory HollandCode.fromJson(Map<String, dynamic> json) {
    return HollandCode(
      primary: json['primary'] ?? '',
      label: json['label'] ?? '',
      distribution: json['distribution'] != null
          ? (json['distribution'] as List)
                .map((i) => HollandCodeDistribution.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary,
      'label': label,
      if (distribution != null)
        'distribution': distribution!.map((v) => v.toJson()).toList(),
    };
  }

  HollandCodeEntity toEntity() {
    return HollandCodeEntity(
      primary: primary,
      label: label,
      distribution: distribution?.map((e) => e.toEntity()).toList(),
    );
  }
}

class CandidateModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String reviewStatus;
  final String processingStatus;
  final List<String> aiSummary;
  final String cvText;
  final List<String> skills;
  final HollandCode? hollandCode;
  final String education;
  final String experience;
  final String portfolioUrl;
  final bool hasPortfolio;
  final num matchScore;
  final String cvFilePath;
  final List<num>? embedding;
  final DateTime? createdAt;

  CandidateModel({
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

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      reviewStatus: json['reviewStatus'] ?? '',
      processingStatus: json['processingStatus'] ?? '',
      aiSummary: json['aiSummary'] != null
          ? List<String>.from(json['aiSummary'])
          : [],
      cvText: json['cvText'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      hollandCode: json['hollandCode'] != null
          ? HollandCode.fromJson(json['hollandCode'])
          : null,
      education: json['education'] ?? '',
      experience: json['experience'] ?? '',
      portfolioUrl: json['portfolioUrl'] ?? '',
      hasPortfolio: json['hasPortfolio'] ?? false,
      matchScore: json['matchScore'] ?? 0,
      cvFilePath: json['cvFilePath'] ?? '',
      embedding: json['embedding'] != null
          ? List<num>.from(json['embedding'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'reviewStatus': reviewStatus,
      'processingStatus': processingStatus,
      'aiSummary': aiSummary,
      'cvText': cvText,
      'skills': skills,
      if (hollandCode != null) 'hollandCode': hollandCode!.toJson(),
      'education': education,
      'experience': experience,
      'portfolioUrl': portfolioUrl,
      'hasPortfolio': hasPortfolio,
      'matchScore': matchScore,
      'cvFilePath': cvFilePath,
      if (embedding != null) 'embedding': embedding,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  CandidateEntity toEntity() {
    return CandidateEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      reviewStatus: reviewStatus,
      processingStatus: processingStatus,
      aiSummary: aiSummary,
      cvText: cvText,
      skills: skills,
      hollandCode: hollandCode?.toEntity(),
      education: education,
      experience: experience,
      portfolioUrl: portfolioUrl,
      hasPortfolio: hasPortfolio,
      matchScore: matchScore,
      cvFilePath: cvFilePath,
      embedding: embedding,
      createdAt: createdAt,
    );
  }
}
