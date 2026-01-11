# Educational Quiz App - Flow Diagram

```mermaid
graph TD
    A[Start] --> B[Authentication Check]
    B --> C{Already have<br/>an account?}
    C -->|NO| D[Create Account Page]
    D --> E[Registration Form]
    E --> F[Register User]
    C -->|YES| G[Login Page]
    G --> H[Validate Credentials]
    F --> I[Home Screen/Dashboard]
    H --> I
    
    I --> J{Select Category}
    
    J -->|Chemistry| K[Chemistry Lessons]
    J -->|Physics| L[Physics Lessons]
    J -->|Biology| M[Biology Lessons]
    J -->|Stats| N[Statistics Screen]
    J -->|Profile| O[Profile Settings]
    
    K --> K1[View Available Quizzes]
    L --> L1[View Available Quizzes]
    M --> M1[View Available Quizzes]
    
    K1 --> K2[Select Quiz]
    L1 --> L2[Select Quiz]
    M1 --> M2[Select Quiz]
    
    K2 --> Q[Quiz Screen]
    L2 --> Q
    M2 --> Q
    
    Q --> Q1[Start Quiz with Timer]
    Q1 --> Q2{Quiz<br/>Complete?}
    Q2 -->|Time Expired| Q3[Auto Submit]
    Q2 -->|Submitted| Q3
    
    Q3 --> R[Results Screen]
    R --> R1[View Score & Explanation]
    R1 --> R2{Continue?}
    R2 -->|Yes| I
    R2 -->|No| S[Save Results to Database]
    
    N --> N1[View User Statistics]
    N1 --> N2[Performance Analytics]
    N2 --> I
    
    O --> O1[Account Settings]
    O --> O2[Preferences]
    O --> O3[About App]
    O1 --> O4[Change Password]
    O2 --> O5[Theme/Language]
    O3 --> O6[Privacy & Terms]
    O4 --> I
    O5 --> I
    O6 --> I
    
    S --> T{Logout?}
    T -->|YES| U[Logout & Return to Login]
    T -->|NO| I
    U --> B
```

## Features in Your App:

### **Authentication Flow:**
- ✅ Create Account → Register User
- ✅ Login → Validate Credentials

### **Main Dashboard (3 Tabs):**
1. **Quizzes Tab** → Subjects (Chemistry/Physics/Biology) → Lessons → Quizzes
2. **Statistics Tab** → Performance metrics
3. **Profile Tab** → Settings & Account management

### **Quiz Flow:**
- ✅ Start Quiz with Timer (countdown display)
- ✅ Auto-submit on time expiry or manual submit
- ✅ View Results with score
- ✅ Save Results to Firebase

### **Profile Settings:**
- Account settings
- Preferences (theme/language)
- About section

---

## To Create a Visual Diagram Online:

### **Option 1: Mermaid Live (Free)**
Paste this diagram at: https://mermaid.live/

### **Option 2: Draw.io (Free)**
1. Go to https://draw.io/
2. Create new diagram
3. Recreate manually with shapes

### **Option 3: Lucidchart**
https://www.lucidchart.com/ (Free tier available)

---

## Next Steps:
Would you like me to:
1. ✅ **Refine the diagram** with more details?
2. ✅ **Add database interactions** (Firebase storage)?
3. ✅ **Create UML class diagrams** for your models?
4. ✅ **Generate this as PNG/SVG** for documentation?
