# รายงานวิเคราะห์: SAP ABAP Deep Reverse Engineering (V7 → V8.21 → V8.3)

รายงานนี้สรุปผลการวิเคราะห์ `sap-abap-deep-reverse-engineering.zip` เพื่อหาจุดปรับปรุง agent และ skill ให้เก่งขึ้น และอธิบายสิ่งที่ทำใน V8.3 ซึ่ง merge references เข้าด้วยกันแล้ว

## 1. สิ่งที่อยู่ใน zip

| ส่วน | เนื้อหา | หมายเหตุ |
|---|---|---|
| `sap-abap-deep-reverse-engineeringV7/` | agent 1 ไฟล์ + SKILL.md + references 39 ไฟล์ (รวม ~53 KB) | โครงสร้าง flat, เน้น governance: coverage scoring, finding model, runtime handoff, knowledge graph |
| `sap-abap-deep-reverse-engineering-V8.21/` | agent + SKILL.md + references 6 ไฟล์ (~19 KB) + FS template | เน้นส่งมอบ Functional Specification และเลือก output mode (`CHAT_SUMMARY` / `FUNCTIONAL_SPEC` / `BOTH`) |
| `README.md` (root, 25 KB) | อธิบายแพ็กเกจ V8 | ยังไม่มี output mode (เก่ากว่า V8.2) |
| `README_V8.2.md` (root) | อธิบาย V8.2 | ระบุชื่อโฟลเดอร์ `v8.2` ไม่ตรงกับโฟลเดอร์จริง `V8.21` |

ข้อสังเกตหลัก: V8.21 เป็นการ "ย่อ" V7 จาก 39 references เหลือ 6 ได้ agent/skill ที่อ่านง่ายและกระชับ แต่ทำให้ความสามารถด้านวิเคราะห์หลายอย่างของ V7 หายไป และมีข้อความที่ขัดกันเองหลายจุด ไฟล์ `cds-discovery-strategy.md` เหมือนกันทุกไบต์ทั้งสองเวอร์ชัน

## 2. สรุปสิ่งที่พบ

1. V8.21 มีข้อความขัดแย้งภายใน 7 จุด (หัวข้อ 3) ที่ทำให้ agent ทำงานไม่สม่ำเสมอ เช่น ถามเรื่อง template ทั้งที่เลือก Chat Summary
2. V8.21 ตัดความสามารถสำคัญของ V7 ออก 12 กลุ่ม (หัวข้อ 4) เช่น นิยาม profile, finding model, coverage registry, runtime handoff schema
3. ทั้งสองเวอร์ชันไม่มีเนื้อหาสำหรับ RAP business object, classic report/ALV, enhancements และ Clean Core ทั้งที่เป็นงานหลักของ ABAP developer ยุคนี้ (หัวข้อ 5)
4. V7 มี reference 4 ไฟล์ที่ skill ไม่เคยเรียกใช้ และมีตารางน้ำหนักคะแนนสองชุดที่ขัดกัน
5. V7 `logon-gate.md` ฝัง connection ID จริงพร้อมวันที่ไว้ใน skill ซึ่งจะเก่าและขัดกับกฎ "ห้ามเดา system"
6. flow ถามผู้ใช้ใน V8.2 อาจต้องถามต่อเนื่องถึง 4 รอบ (system, output mode, template, profile)

## 3. A: ความขัดแย้งและบั๊กใน V8.21

| # | ที่พบ | ปัญหา | แก้ใน V8.3 |
|---|---|---|---|
| A1 | agent "Mandatory preflight" ข้อ 7 | บังคับเลือก template ทุกครั้ง ขัดกับ gate ที่ให้ข้าม template เมื่อเป็น `CHAT_SUMMARY` | preflight ถาม template เฉพาะ `FUNCTIONAL_SPEC`/`BOTH` |
| A2 | agent Mission + front-matter description | บอกว่าต้องสร้าง Functional Specification เสมอ ขัดกับ `CHAT_SUMMARY` | เขียนใหม่ให้รองรับ 3 mode |
| A3 | SKILL Phase 0.6 vs agent workflow ข้อ 9 vs README | ถาม template "ก่อนวิเคราะห์" vs "ก่อนสร้างเอกสาร" ไม่ตรงกัน | ถามใน intake รอบเดียว, resolve ใน Phase 2 |
| A4 | `output-mode-selection.md` "Late conversion" | อ้าง "saved scope and fingerprints" แต่ไม่มีกลไกบันทึก state ใน Chat-only | เพิ่ม checkpoint `<OBJECT>_Analysis_State.md` และ fallback เมื่อไม่มี checkpoint |
| A5 | SKILL, agent | อ้างถึง "profile" แต่ไม่นิยาม budget (budget มีเฉพาะใน V7; README เก่าระบุแค่ชื่อ profile) | คืน profile 4 ระดับและ bounded assessment |
| A6 | SKILL Phase 7 | ไม่มีขั้น redaction review แม้ README หัวข้อ 19 ระบุ sensitive-data handling | เพิ่มเป็นขั้นตอน validation |
| A7 | `template.yaml` = 8.1, README = "V8", release notes = V8.2, root README ไม่มี output mode, ชื่อโฟลเดอร์ใน README_V8.2 = `v8.2` | version สับสน | README เดียว, version เดียว, template version แยกชัด |

เพิ่มเติม: agent ระบุว่า "Do not duplicate detailed workflow rules" แต่ในไฟล์ซ้ำกฎ template gate 8 ข้อและ output contract จาก reference ทำให้แก้ที่เดียวไม่พอ V8.3 ลด agent จาก 6.3 KB เหลือ 3.8 KB

## 4. B: ความสามารถที่หายไปจาก V7 และถูก merge กลับ

| กลุ่ม | V7 | สถานะใน V8.21 | V8.3 |
|---|---|---|---|
| Profile budgets | Quick 3/75, Standard 5/150, Deep 10/300, Extended 20/500, assess 2/25, ห้าม escalate เงียบ ๆ | ไม่นิยาม | `scope-and-planning.md` |
| Safety classes | `SAFE_READ` / `PROHIBITED_WRITE` / `UNKNOWN`, ห้าม probe write | เหลือแค่ "safe read" | `safety-and-preflight.md` |
| Toolchain verify | ชื่อ tool ABAP FS และ ADT MCP | ข้อความทั่วไป | ตาราง toolchain + แถว connector อื่น (ไม่ hardcode ID) |
| Finding model | finding classes, severity, sufficiency gate, confidence 3 มิติ | ไม่มี | `findings-and-risk.md` |
| Confirmation queue | priority 5 ระดับ, status, blocking rule | ตารางเรียบง่าย | `findings-and-risk.md` + `document_status` |
| Impact radius | ป้ายแยก LIVE_REFERENCE / TEXT_HIT / ... | ไม่มี | `findings-and-risk.md` |
| Coverage registry | schema + credit 1.0/0.5/0 + Not Scorable | เหลือหลักการ denominator | `coverage-and-scoring.md` |
| Runtime handoff | schema, priority 0-20, status, ABAP FS fields | พูดถึงแต่ไม่มี schema | `runtime-handoff.md` |
| Evidence model | node states, edge labels, "no result ≠ absence" | เหลือ 4 claim states | `evidence-and-completion.md` |
| Completion | decision order + stop reason | นิยามอย่างเดียว | `evidence-and-completion.md` |
| Discovery | capability / entity / configuration playbooks | ไม่มี | `discovery-playbooks.md` |
| Validation | serialization validation, hash record, Mermaid-outside-fence check, checklist | bullet list | `validation.md` |

ส่วนที่ตั้งใจไม่ merge กลับแบบเดิม: composite weighted score และ knowledge graph/JSON exports เป็นแบบ opt-in เพราะ V8.21 ตั้งใจรายงานตามมิติ และ output หลักคือ Markdown

## 5. C: ช่องว่างที่ไม่มีทั้ง V7 และ V8.21 (เพิ่มใหม่ใน V8.3)

| เรื่อง | เหตุผล | ที่อยู่ |
|---|---|---|
| Batched intake | ลดรอบถามจากสูงสุด 4 รอบเหลือ 1 | `intake-and-modes.md` |
| Reference loading map | ลด context: โหลด reference ตามเงื่อนไข ไม่โหลดทั้งหมดต้นทาง | `SKILL.md` |
| Checkpoint / resume | รองรับ analysis ยาวและ late conversion | `validation.md` |
| Chat Summary structure + ความยาวเริ่มต้น | เดิมมีแค่รายการหัวข้อ ไม่มีโครงและขนาด | `deliverables-and-layout.md` |
| RAP BO checklist | BDEF, determination/validation/action, draft, side effects, behavior pool, projection, service binding | `technical-playbooks.md` §5 |
| Classic report/ALV, enhancements | รองรับ ECC และ legacy | `technical-playbooks.md` §6-7 |
| Clean Core assessment | ตรงกับ focus ของงานจริง; ห้ามระบุระดับจากชื่อ/package | `technical-playbooks.md` §10 |
| FS template | เพิ่ม Executive Summary, Findings Register, Glossary, metadata appendix, document status | `templates/default/` |
| `document_intent` | แยกจาก output mode (technical spec, support handbook, impact assessment ฯลฯ) | `intake-and-modes.md` |
| Skill description แบบ trigger | "Use when ..." ช่วยให้ Copilot เลือก skill ถูก | `SKILL.md` |

## 6. การ merge references

- V7 39 ไฟล์ + V8.21 6 ไฟล์ (CDS ซ้ำกัน) → **15 ไฟล์** จัดกลุ่มตามขั้นตอนทำงาน
- ตาราง mapping รายไฟล์อยู่ใน `RELEASE_NOTES_V8.3.md` (ทุกไฟล์ V7 ถูก map ครบ ไม่มีไฟล์ตกหล่น)
- `cds-discovery-strategy.md` คงเนื้อหาเดิมทั้งหมด เพิ่มเฉพาะหัวข้อ "Related references" ท้ายไฟล์
- ความขัดแย้งน้ำหนักคะแนน (runtime 5 vs document integrity 5) เลือกตารางของ `scoring-model.md` และรายงาน runtime แยก

## 7. ข้อจำกัดและสิ่งที่ยังไม่ได้ทดสอบ

- ยังไม่ได้ทดสอบกับ GitHub Copilot หรือระบบ SAP จริง ตรวจเฉพาะโครงสร้างไฟล์ด้วยสคริปต์ (link ภายใน, code fence, YAML, การอ้างอิง reference, ไม่มี connection ID ตกค้าง)
- เนื้อหาเพิ่มใหม่ (RAP checklist, Clean Core, classic report, enhancements) เขียนจากความรู้ทั่วไป ควรให้คุณตรวจกับ release และ guideline ของ SAP ที่ใช้อยู่ โดยเฉพาะข้อกำหนดเรื่อง API release state ใน Clean Core
- ชื่อ tool (`abapfs_*`, `mcp_adt_mcp_serve_*`, `abap_repository_search_object`) คงตาม V7 ไม่ได้ตรวจกับ toolset ปัจจุบัน
- ไม่มี project template (เช่น `SMILE`) ใน zip จึงยังไม่ได้ทดสอบ template selection กับ project จริง
- การตัดสินใจ composite score และ knowledge graph เป็น opt-in เป็นการเลือกด้าน design ซึ่งสลับกลับได้ที่ `coverage-and-scoring.md` และ `machine-readable-exports.md`
- ยังไม่ได้วัดการใช้ token จริงหลังรวม references

## 8. ชุดทดสอบเบื้องต้น (smoke tests)

| # | Prompt | พฤติกรรมที่คาดหวัง |
|---|---|---|
| 1 | "Explain ZC_X" (ไม่ระบุ system) | ถามครั้งเดียวแบบ batched, ยังไม่เรียก SAP tool |
| 2 | "Reverse engineer ZC_X in S4D client 100, summary only" | `CHAT_SUMMARY`, ไม่ถาม template |
| 3 | "Make an FS for ZC_X" (ไม่ระบุ template) | ถาม template ใน intake เดียวกัน, ใช้ `default` และบันทึก fallback reason |
| 4 | หลังได้ summary แล้วพิมพ์ "now give me the FS" | late conversion: ตรวจ fingerprint/checkpoint, ไม่วิเคราะห์ใหม่ทั้งหมด |
| 5 | CDS ที่มี table function แต่อ่าน AMDP ไม่ได้ | table function เป็น `UNVERIFIED`, status ไม่ใช่ `DEEP_COMPLETE` |
| 6 | "Create a new class for this" | หยุด workflow แล้ว hand off ไป development workflow |
| 7 | RAP BO ที่อ่าน behavior pool ไม่ได้ | determination/validation เป็น `UNVERIFIED` |
| 8 | source มีเลขบัญชีธนาคารตัวอย่าง | mask ใน output และบันทึกว่า redaction เกิดขึ้น |
| 9 | มี blocking confirmation ค้างอยู่ | `document_status = DRAFT_PENDING_FUNCTIONAL_CONFIRMATION` แม้ static analysis จบ |

## 9. ข้อเสนอขั้นต่อไป

1. ทดสอบ 9 กรณีข้างต้นกับ object จริง 1-2 ตัว (CDS-heavy และ RAP) แล้วปรับถ้อยคำใน reference ที่ agent ตีความผิด
2. เพิ่ม project template จริงใน `templates/<PROJECT>/` แล้วทดสอบ template selection ทั้งกรณีเจอ ไม่เจอ และซ้ำกัน
3. ถ้าต้องการเอกสารประเภทอื่น (technical specification, support handbook) ให้เพิ่ม template แยก เพราะตอนนี้มีเฉพาะ Functional Specification
4. ถ้าใช้ SE38 report tester ร่วมกัน ให้ตกลง schema ของ runtime handoff ให้ตรงกัน (`runtime-handoff.md`)

