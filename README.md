# Thermodynamic Cycles

This repository contains MATLAB codes for analyzing and simulating the **Otto Cycle** (Spark Ignition engine) and **Diesel Cycle** (Compression Ignition engine). These are fundamental thermodynamic cycles used to model internal combustion engines.  

---

## 📌 Features  

- Calculates **state variables** (P, V, T) at all major cycle points  
- Computes **cycle efficiency, heat addition, heat rejection, and net work done**  
- Plots **P–V diagram** of the cycle  
- Generates a **Compression Ratio (CR) vs Efficiency graph** to show thermodynamic trends  

---

## ⚙️ Codes  

### 🔹 Otto Cycle (`otto_cycle.m`)  
- **Inputs:**
  - Compression ratio (r)  
  - Initial pressure (p1)  
  - Initial temperature (T1)  
  - Heat added at constant volume (Qin)  

- **Outputs:**  
  - State variables (P1–P4, T1–T4)  
  - Theoretical efficiency  
  - Heat rejected & Net work done  
  - Graphs:  
    - P–V diagram  
    - CR vs Efficiency  

---

### 🔹 Diesel Cycle (`diesel_cycle.m`)  
- **Inputs:**
  - Cylinder Bore diameter(mm)
  - Cylinder Stroke Length (mm)
  - No. of cylinders  
  - Compression ratio (r)  
  - Cut-off ratio (rc)  
  - Initial pressure (p1)  
  - Initial temperature (T1)  
  - Heat added at constant pressure (Qin)  

- **Outputs:**  
  - State variables (P1–P4, T1–T4)  
  - Theoretical efficiency  
  - Heat rejected & Net work done  
  - Graphs:  
    - P–V diagram  
    - CR vs Efficiency  

---

## 🚀 How to Run  

1. Clone the repository:  
   ```bash
   git clone https://github.com/yourusername/yourrepo.git
   cd yourrepo
