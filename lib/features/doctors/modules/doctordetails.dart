class DoctorDetails {
  String? sId;
  String? name;
  int? age;
  String? email;
  bool? isVerified;
  String? role;
  String? createdAt;
  int? iV;
  List<String>? followers;
  List<dynamic>? following;
  String? profileImage;
  ProfessionalProfile? professionalProfile;

  DoctorDetails({
    this.sId,
    this.name,
    this.age,
    this.email,
    this.isVerified,
    this.role,
    this.createdAt,
    this.iV,
    this.followers,
    this.following,
    this.profileImage,
    this.professionalProfile,
  });

  DoctorDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    age = json['age'];
    email = json['email'];
    isVerified = json['isVerified'];
    role = json['role'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    followers = json['followers']?.cast<String>();
    following = json['following']?.cast<dynamic>();
    profileImage = json['profileImage'];
    professionalProfile = json['professionalProfile'] != null
        ? ProfessionalProfile.fromJson(json['professionalProfile'])
        : null;
  }
}

class ProfessionalProfile {
  String? headline;
  String? bio;
  List<String>? languages;
  int? pricePerSession;
  bool? verified;
  List<dynamic>? availability;

  ProfessionalProfile({
    this.headline,
    this.bio,
    this.languages,
    this.pricePerSession,
    this.verified,
    this.availability,
  });

  ProfessionalProfile.fromJson(Map<String, dynamic> json) {
    headline = json['headline'];
    bio = json['bio'];
    languages = json['languages']?.cast<String>();
    pricePerSession = json['price_per_session'];
    verified = json['verified'];
    availability = json['availability']?.cast<dynamic>();
  }
}
