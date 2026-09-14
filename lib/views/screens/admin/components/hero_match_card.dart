import 'package:flutter/material.dart';
import '../../../../models/match_candidate.dart';

class HeroMatchCard extends StatelessWidget {
  const HeroMatchCard({
    super.key,
    required this.candidate,
  });

  final MatchCandidate candidate;

  static const navyDark = Color(0xFF1E293B);
  static const blueAccent = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dark Header Banner
          _buildBannerHeader(),

          // 2-Column or Stacked Comparison Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildLostCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFoundCard()),
                    ],
                  )
                : Column(
                    children: [
                      _buildLostCard(),
                      const SizedBox(height: 16),
                      _buildFoundCard(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        color: navyDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, bannerConstraints) {
          final similarityBadge = Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: CircularProgressIndicator(
                        value: candidate.similarityScore / 100,
                        strokeWidth: 3.5,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                      ),
                    ),
                    Text(
                      '${candidate.similarityScore}%',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SIMILARITY SCORE',
                        style: TextStyle(color: Color(0xFFF59E0B), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      Text(
                        candidate.similarityBadge,
                        style: const TextStyle(color: Colors.white70, fontSize: 10.5, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          if (bannerConstraints.maxWidth > 520) {
            return Row(
              children: [
                // Icon Box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),

                // Title & Candidate ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'CANDIDATE MATCH ${candidate.id}',
                            style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                          const SizedBox(width: 8),
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFF38BDF8), shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          const Text(
                            'AI Auto-Paired',
                            style: TextStyle(fontSize: 10, color: Color(0xFF38BDF8), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        candidate.priorityLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                similarityBadge,
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CANDIDATE MATCH ${candidate.id}',
                            style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            candidate.priorityLabel,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                similarityBadge,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildLostCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Chip & Date
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(4)),
                    child: const Text('LOST REPORT', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Text(candidate.lostReportId, style: const TextStyle(fontSize: 10.5, color: Colors.black54, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.black45),
                  const SizedBox(width: 4),
                  Text(candidate.lostDate, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Image Preview and Basic Specs
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageThumbnail(tag: 'User Upload', icon: Icons.laptop_mac),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _tagChip(candidate.lostItemCategory),
                        if (candidate.lostItemModel != null) _tagChip(candidate.lostItemModel!),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      candidate.lostItemTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    _infoRow(Icons.person_outline, 'Reporter: ${candidate.reporterName} (${candidate.reporterId ?? ""})'),
                    const SizedBox(height: 4),
                    _infoRow(Icons.location_on_outlined, 'Location: ${candidate.lostLocation}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Distinct marks notes
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'REPORT DETAILS & DISTINCT MARKS:',
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  candidate.lostNotes,
                  style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Footer Badges
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(candidate.lostBadge1, style: const TextStyle(fontSize: 10, color: Colors.black45)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, size: 13, color: Colors.green),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      candidate.lostBadge2,
                      style: const TextStyle(fontSize: 10.5, color: Colors.green, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoundCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Chip & Date
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFD97706), borderRadius: BorderRadius.circular(4)),
                    child: const Text('FOUND ITEM', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Text(candidate.foundItemId, style: const TextStyle(fontSize: 10.5, color: Colors.black54, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.black45),
                  const SizedBox(width: 4),
                  Text(candidate.foundDate, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Image Preview and Basic Specs
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageThumbnail(tag: 'Intake Scan', icon: Icons.camera_alt_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _tagChip(candidate.foundItemCategory, bgColor: const Color(0xFFFEF3C7), textColor: const Color(0xFF92400E)),
                        if (candidate.foundVaultBin != null) _tagChip(candidate.foundVaultBin!),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      candidate.foundItemTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    _infoRow(Icons.security, 'Finder: ${candidate.finderName}'),
                    const SizedBox(height: 4),
                    _infoRow(Icons.location_on_outlined, 'Location: ${candidate.foundLocation}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Physical inventory notes
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FOUND PHYSICAL INVENTORY NOTES:',
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  candidate.foundNotes,
                  style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Footer Badges
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(candidate.custodyLocation, style: const TextStyle(fontSize: 10, color: Colors.black45)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 13, color: Colors.green),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      candidate.foundBadge2,
                      style: const TextStyle(fontSize: 10.5, color: Colors.green, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail({required String tag, required IconData icon}) {
    return Stack(
      children: [
        Container(
          width: 110,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.black45),
              const SizedBox(height: 4),
              const Text('Photo Record', style: TextStyle(fontSize: 9, color: Colors.black45)),
            ],
          ),
        ),
        Positioned(
          left: 4,
          top: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tagChip(String text, {Color? bgColor, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: textColor ?? const Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: Colors.black45),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
