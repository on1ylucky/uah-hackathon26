import Foundation

struct MockData {

    static let lockedApps: [LockedApp] = [
        LockedApp(name: "Instagram", icon: "camera.fill", requiredCorrect: 5),
        LockedApp(name: "TikTok", icon: "music.note", requiredCorrect: 10),
        LockedApp(name: "YouTube", icon: "play.rectangle.fill", requiredCorrect: 15)
    ]

    // MARK: MATH
    static let mathStudySet = StudySet(
        title: "Algebra & Math",
        subject: "Math",
        questions: [

            // EASY (10)
            StudyQuestion(prompt: "7 × 8", answer: "56", choices: ["56","54","48","64"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "12²", answer: "144", choices: ["144","124","132","156"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "√81", answer: "9", choices: ["9","8","7","6"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "5³", answer: "125", choices: ["125","25","75","100"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "10 + 15", answer: "25", choices: ["25","20","30","35"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "100 ÷ 10", answer: "10", choices: ["10","5","20","15"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "9 × 6", answer: "54", choices: ["54","48","56","60"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "3²", answer: "9", choices: ["9","6","12","3"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "15 - 7", answer: "8", choices: ["8","7","9","6"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "2 × 9", answer: "18", choices: ["18","16","20","14"], difficulty: .easy, explanation: nil),

            // MEDIUM (10)
            StudyQuestion(prompt: "Solve: 3x + 6 = 15", answer: "3", choices: ["3","2","4","5"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Solve: 2x = 14", answer: "7", choices: ["7","6","8","9"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What is 25% of 200?", answer: "50", choices: ["50","25","75","100"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Solve: x/4 = 5", answer: "20", choices: ["20","15","25","10"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What is 11²?", answer: "121", choices: ["121","111","131","101"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Solve: 4x + 2 = 18", answer: "4", choices: ["4","5","3","6"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What is 20% of 150?", answer: "30", choices: ["30","25","35","40"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Solve: 5x = 45", answer: "9", choices: ["9","8","7","10"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Solve: x - 7 = 10", answer: "17", choices: ["17","15","18","16"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What is 13 × 7?", answer: "91", choices: ["91","81","101","84"], difficulty: .medium, explanation: nil),

            // HARD (10)
            StudyQuestion(prompt: "Derivative of x²", answer: "2x", choices: ["2x","x","x²","2"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Integral of 1 dx", answer: "x", choices: ["x","1","x²","0"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Solve: x² = 49", answer: "7", choices: ["7","-7","±7","14"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What is log₁₀(100)?", answer: "2", choices: ["2","10","1","100"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Derivative of 3x", answer: "3", choices: ["3","x","0","6"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What is π approximately?", answer: "3.14", choices: ["3.14","2.14","4.13","3.41"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Solve: x² + 1 = 0", answer: "i", choices: ["i","-1","1","0"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Derivative of x³", answer: "3x²", choices: ["3x²","x²","3x","x³"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What is 2⁵?", answer: "32", choices: ["32","16","64","48"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What is √144?", answer: "12", choices: ["12","11","13","10"], difficulty: .hard, explanation: nil)
        ]
    )

    // MARK: ANATOMY
    static let anatomyStudySet = StudySet(
        title: "Human Anatomy",
        subject: "Biology",
        questions: [
            // EASY (10)
            StudyQuestion(prompt: "Thigh bone", answer: "Femur", choices: ["Femur","Tibia","Fibula","Humerus"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Collarbone", answer: "Clavicle", choices: ["Clavicle","Scapula","Rib","Spine"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Shoulder blade", answer: "Scapula", choices: ["Scapula","Clavicle","Rib","Ulna"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Upper arm bone", answer: "Humerus", choices: ["Humerus","Femur","Radius","Tibia"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Skull protects?", answer: "Brain", choices: ["Brain","Heart","Lungs","Spine"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Shin bone", answer: "Tibia", choices: ["Tibia","Fibula","Femur","Pelvis"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Forearm bone", answer: "Radius", choices: ["Radius","Femur","Tibia","Clavicle"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Ribs protect?", answer: "Heart", choices: ["Heart","Brain","Legs","Skin"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Lower leg small bone", answer: "Fibula", choices: ["Fibula","Femur","Ulna","Radius"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Hand bones called?", answer: "Metacarpals", choices: ["Metacarpals","Femur","Ulna","Radius"], difficulty: .easy, explanation: nil),

            // MEDIUM (10)
            StudyQuestion(prompt: "Bone in forearm (pinky side)", answer: "Ulna", choices: ["Ulna","Radius","Femur","Tibia"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Bone connecting arm to body", answer: "Scapula", choices: ["Scapula","Clavicle","Rib","Spine"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Hip bone", answer: "Pelvis", choices: ["Pelvis","Femur","Tibia","Spine"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Backbone called?", answer: "Spine", choices: ["Spine","Skull","Rib","Femur"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Knee cap", answer: "Patella", choices: ["Patella","Femur","Tibia","Ulna"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Bone in foot", answer: "Tarsals", choices: ["Tarsals","Metacarpals","Radius","Ulna"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Bone in fingers", answer: "Phalanges", choices: ["Phalanges","Femur","Clavicle","Tibia"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Chest bone", answer: "Sternum", choices: ["Sternum","Rib","Clavicle","Spine"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Bone above knee", answer: "Femur", choices: ["Femur","Tibia","Fibula","Ulna"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Bone below knee", answer: "Tibia", choices: ["Tibia","Femur","Radius","Ulna"], difficulty: .medium, explanation: nil),

            // HARD (10)
            StudyQuestion(prompt: "Small wrist bones called?", answer: "Carpals", choices: ["Carpals","Tarsals","Phalanges","Metacarpals"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Bone of jaw", answer: "Mandible", choices: ["Mandible","Maxilla","Clavicle","Sternum"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Upper jaw bone", answer: "Maxilla", choices: ["Maxilla","Mandible","Pelvis","Scapula"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Longest bone", answer: "Femur", choices: ["Femur","Tibia","Spine","Humerus"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Bone between shoulder and elbow", answer: "Humerus", choices: ["Humerus","Radius","Ulna","Femur"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Bone in heel", answer: "Calcaneus", choices: ["Calcaneus","Talus","Femur","Tibia"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Bone in ankle", answer: "Talus", choices: ["Talus","Femur","Ulna","Radius"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Bone in spine called?", answer: "Vertebrae", choices: ["Vertebrae","Ribs","Femur","Ulna"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Shoulder joint bone", answer: "Scapula", choices: ["Scapula","Femur","Tibia","Pelvis"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Bone connecting ribs", answer: "Sternum", choices: ["Sternum","Clavicle","Spine","Ulna"], difficulty: .hard, explanation: nil)
        ]
    )

    // MARK: CHEMISTRY
    static let chemistryStudySet = StudySet(
        title: "Chemical Symbols",
        subject: "Chemistry",
        questions: [
            // EASY (10)
            StudyQuestion(prompt: "Gold", answer: "Au", choices: ["Au","Ag","Gd","Go"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Oxygen", answer: "O", choices: ["O","Ox","Og","Oo"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Carbon", answer: "C", choices: ["C","Ca","Co","Cr"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Hydrogen", answer: "H", choices: ["H","He","Ho","Hy"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Nitrogen", answer: "N", choices: ["N","Ni","Na","Ne"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Helium", answer: "He", choices: ["He","H","Hg","Ho"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Chlorine", answer: "Cl", choices: ["Cl","C","Ch","Cr"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Calcium", answer: "Ca", choices: ["Ca","C","Cl","Cr"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Iron", answer: "Fe", choices: ["Fe","Ir","In","I"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Silver", answer: "Ag", choices: ["Ag","Au","Si","Sl"], difficulty: .easy, explanation: nil),

            // MEDIUM (10)
            StudyQuestion(prompt: "Sodium", answer: "Na", choices: ["Na","So","Sn","S"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Potassium", answer: "K", choices: ["K","P","Pt","Po"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Magnesium", answer: "Mg", choices: ["Mg","Mn","Mo","Ma"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Zinc", answer: "Zn", choices: ["Zn","Z","Zi","Zo"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Copper", answer: "Cu", choices: ["Cu","Co","Cp","Cr"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Lead", answer: "Pb", choices: ["Pb","Ld","Le","La"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Tin", answer: "Sn", choices: ["Sn","Tn","Ti","Ta"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Fluorine", answer: "F", choices: ["F","Fl","Fr","Fo"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Phosphorus", answer: "P", choices: ["P","Ph","Po","Pr"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Sulfur", answer: "S", choices: ["S","Su","So","Sf"], difficulty: .medium, explanation: nil),

            // HARD (10)
            StudyQuestion(prompt: "Mercury", answer: "Hg", choices: ["Hg","Me","Mc","Hy"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Antimony", answer: "Sb", choices: ["Sb","An","Am","As"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Tungsten", answer: "W", choices: ["W","Tu","Tn","Te"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Chromium", answer: "Cr", choices: ["Cr","Ch","Cm","C"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Cobalt", answer: "Co", choices: ["Co","Cb","Ct","Cl"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Nickel", answer: "Ni", choices: ["Ni","Nk","Ne","Na"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Barium", answer: "Ba", choices: ["Ba","Br","Be","Bi"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Radon", answer: "Rn", choices: ["Rn","Ra","Ro","Rd"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Xenon", answer: "Xe", choices: ["Xe","Xn","Xo","Xu"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Neon", answer: "Ne", choices: ["Ne","N","No","Na"], difficulty: .hard, explanation: nil)
        ]
    )

    // MARK: SECURITY+
    static let securityPlusStudySet = StudySet(
        title: "Security+ Study Set",
        subject: "Cybersecurity",
        questions: [
            StudyQuestion(prompt: "What does CIA stand for in cybersecurity?", answer: "Confidentiality, Integrity, Availability", choices: ["Confidentiality, Integrity, Availability","Control, Inspection, Authentication","Cyber, Internet, Access","Confidentiality, Insurance, Authority"], difficulty: .easy, explanation: "The CIA triad is a foundational security model."),
            StudyQuestion(prompt: "Which type of malware demands payment to restore access?", answer: "Ransomware", choices: ["Ransomware","Spyware","Adware","Worm"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "What does MFA stand for?", answer: "Multi-Factor Authentication", choices: ["Multi-Factor Authentication","Managed Firewall Access","Multiple File Authorization","Mainframe Access"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Which attack tricks users into revealing sensitive information?", answer: "Phishing", choices: ["Phishing","Spoofing","Hashing","Patching"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "What device filters incoming and outgoing network traffic?", answer: "Firewall", choices: ["Firewall","Router","Switch","Load balancer"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "What does VPN stand for?", answer: "Virtual Private Network", choices: ["Virtual Private Network","Verified Protected Node","Virtual Protected Net","Variable Private Network"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Which principle gives users only the access they need?", answer: "Least Privilege", choices: ["Least Privilege","Open Access","Defense in Depth","Nonrepudiation"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "What is malicious software called?", answer: "Malware", choices: ["Malware","Firmware","Shareware","Middleware"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Which kind of attack overloads a system with traffic?", answer: "DoS", choices: ["DoS","Phishing","Brute force","Privilege escalation"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "What is the process of converting readable data into unreadable data called?", answer: "Encryption", choices: ["Encryption","Hashing","Tokenizing","Obfuscation"], difficulty: .easy, explanation: nil),

            StudyQuestion(prompt: "Which attack injects malicious SQL into an input field?", answer: "SQL Injection", choices: ["SQL Injection","Phishing","Cross-site request forgery","Buffer overflow"], difficulty: .medium, explanation: "SQL injection targets database queries through user input."),
            StudyQuestion(prompt: "What type of control is a security awareness training program?", answer: "Administrative", choices: ["Administrative","Technical","Physical","Compensating"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Which security model focuses on layered protections?", answer: "Defense in Depth", choices: ["Defense in Depth","Least Privilege","Zero Trust","Single Sign-On"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What is the act of verifying identity called?", answer: "Authentication", choices: ["Authentication","Authorization","Accounting","Attribution"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What is the term for proving an action cannot be denied later?", answer: "Nonrepudiation", choices: ["Nonrepudiation","Integrity","Availability","Confidentiality"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Which protocol is commonly used to securely browse websites?", answer: "HTTPS", choices: ["HTTPS","HTTP","FTP","Telnet"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What kind of attack tries many passwords rapidly?", answer: "Brute Force", choices: ["Brute Force","Phishing","Replay","Tailgating"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Which type of malware records keystrokes?", answer: "Keylogger", choices: ["Keylogger","Rootkit","Trojan","Worm"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What security concept assumes no user or device should be trusted by default?", answer: "Zero Trust", choices: ["Zero Trust","Least Privilege","Defense in Depth","Single Sign-On"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "What is a biometric authentication factor based on?", answer: "Something you are", choices: ["Something you are","Something you know","Something you have","Somewhere you are"], difficulty: .medium, explanation: nil),

            StudyQuestion(prompt: "What type of assessment simulates a real-world attack to test defenses?", answer: "Penetration Test", choices: ["Penetration Test","Vulnerability Scan","Baseline Review","Patch Audit"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Which framework function in NIST CSF focuses on restoring capabilities after an incident?", answer: "Recover", choices: ["Recover","Detect","Protect","Identify"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What is the primary purpose of a salt in password hashing?", answer: "To make identical passwords hash differently", choices: ["To make identical passwords hash differently","To compress the password","To encrypt the hash","To shorten the password"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Which concept limits lateral movement by dividing a network into smaller zones?", answer: "Segmentation", choices: ["Segmentation","Redundancy","Tokenization","Federation"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Which attack captures and retransmits valid data to impersonate a user?", answer: "Replay Attack", choices: ["Replay Attack","Phishing","DDoS","Whaling"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What kind of vulnerability occurs when software writes beyond the bounds of allocated memory?", answer: "Buffer Overflow", choices: ["Buffer Overflow","Race Condition","SQL Injection","Directory Traversal"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What is the main purpose of a SIEM?", answer: "Centralized log collection and security event analysis", choices: ["Centralized log collection and security event analysis","Patch management","Device imaging","Password recovery"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Which concept ensures a system continues operating despite component failure?", answer: "Fault Tolerance", choices: ["Fault Tolerance","Nonrepudiation","Obfuscation","Deprecation"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "What is the difference between identification and authentication?", answer: "Identification claims an identity; authentication verifies it", choices: ["Identification claims an identity; authentication verifies it","Authentication claims identity; identification verifies it","They mean the same thing","Identification authorizes access"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Which security testing method is performed without prior knowledge of the environment?", answer: "Black Box Testing", choices: ["Black Box Testing","White Box Testing","Gray Box Testing","Regression Testing"], difficulty: .hard, explanation: nil)
        ]
    )

    // MARK: TRIVIA
    static let triviaStudySet = StudySet(
        title: "Trivia",
        subject: "Mixed",
        questions: [
            StudyQuestion(prompt: "Capital of France", answer: "Paris", choices: ["Paris","London","Rome","Berlin"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Red planet", answer: "Mars", choices: ["Mars","Earth","Venus","Jupiter"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Fastest land animal", answer: "Cheetah", choices: ["Cheetah","Lion","Tiger","Horse"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Largest ocean", answer: "Pacific", choices: ["Pacific","Atlantic","Indian","Arctic"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "2 + 2", answer: "4", choices: ["4","3","5","6"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Color of sky", answer: "Blue", choices: ["Blue","Red","Green","Yellow"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "How many days in a week?", answer: "7", choices: ["7","5","6","8"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Primary gas we breathe", answer: "Oxygen", choices: ["Oxygen","Carbon","Hydrogen","Nitrogen"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Largest continent", answer: "Asia", choices: ["Asia","Africa","Europe","Australia"], difficulty: .easy, explanation: nil),
            StudyQuestion(prompt: "Water freezes at?", answer: "0", choices: ["0","10","-10","5"], difficulty: .easy, explanation: nil),

            StudyQuestion(prompt: "Who wrote Hamlet?", answer: "Shakespeare", choices: ["Shakespeare","Hemingway","Twain","Dickens"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Largest planet", answer: "Jupiter", choices: ["Jupiter","Saturn","Mars","Earth"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "H2O is?", answer: "Water", choices: ["Water","Oxygen","Hydrogen","Salt"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Speed of light approx (km/s)", answer: "300000", choices: ["300000","150000","100000","500000"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Currency of Japan", answer: "Yen", choices: ["Yen","Won","Dollar","Euro"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Largest desert", answer: "Sahara", choices: ["Sahara","Gobi","Arctic","Antarctic"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "First man on moon", answer: "Neil Armstrong", choices: ["Neil Armstrong","Buzz Aldrin","Yuri Gagarin","John Glenn"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Square root of 64", answer: "8", choices: ["8","6","7","9"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Gas for photosynthesis", answer: "Carbon dioxide", choices: ["Carbon dioxide","Oxygen","Nitrogen","Hydrogen"], difficulty: .medium, explanation: nil),
            StudyQuestion(prompt: "Largest mammal", answer: "Blue whale", choices: ["Blue whale","Elephant","Shark","Giraffe"], difficulty: .medium, explanation: nil),

            StudyQuestion(prompt: "Smallest prime number", answer: "2", choices: ["2","1","3","5"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Heaviest naturally occurring element", answer: "Uranium", choices: ["Uranium","Gold","Lead","Iron"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "First programming language", answer: "Fortran", choices: ["Fortran","C","Python","Java"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Deepest ocean trench", answer: "Mariana Trench", choices: ["Mariana Trench","Atlantic Ridge","Java Trench","Tonga Trench"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Binary of 2", answer: "10", choices: ["10","11","01","00"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Atomic number of carbon", answer: "6", choices: ["6","8","12","4"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Largest bone in body", answer: "Femur", choices: ["Femur","Tibia","Spine","Skull"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Hardest natural substance", answer: "Diamond", choices: ["Diamond","Gold","Iron","Quartz"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Value of π (rounded)", answer: "3.14", choices: ["3.14","2.71","1.61","3.41"], difficulty: .hard, explanation: nil),
            StudyQuestion(prompt: "Chemical formula for salt", answer: "NaCl", choices: ["NaCl","KCl","Na","Cl"], difficulty: .hard, explanation: nil)
        ]
    )

    static let allStudySets: [StudySet] = [
        mathStudySet,
        anatomyStudySet,
        chemistryStudySet,
        securityPlusStudySet,
        triviaStudySet
    ]
}
