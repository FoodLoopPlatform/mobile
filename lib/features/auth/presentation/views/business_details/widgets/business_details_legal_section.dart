import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/enums/account_type_enum.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/auth/presentation/views/business_details/widgets/document_tile.dart';
import 'package:foodloop/features/auth/presentation/views/business_details/widgets/section_header.dart';

/// Callback signature: maps each document API-type → picked File (or null).
typedef DocumentsChangedCallback = void Function(Map<String, File?> documents);

class BusinessDetailsLegalSection extends StatefulWidget {
  const BusinessDetailsLegalSection({
    super.key,
    required this.accountType,
    required this.onDocumentsChanged,
    this.initialDocuments = const {},
  });

  /// Determines which set of documents to display (merchant vs. charity).
  final AccountType accountType;
  final DocumentsChangedCallback onDocumentsChanged;
  final Map<String, File?> initialDocuments;

  @override
  State<BusinessDetailsLegalSection> createState() =>
      _BusinessDetailsLegalSectionState();
}

class _BusinessDetailsLegalSectionState
    extends State<BusinessDetailsLegalSection> {
  /// Each descriptor carries:
  ///   [type]  – the exact value sent to the API as `Type`.
  ///   [title] – the Arabic display label shown to the user.
  late final List<_DocDescriptor> _docs;

  /// Keyed by [type] (the API enum value), not the display label.
  final Map<String, File?> _pickedFiles = {};

  @override
  void initState() {
    super.initState();
    _docs = _buildDescriptors(widget.accountType);

    // Initialise map so parent always sees all keys, then overlay any
    // previously picked files from the draft.
    for (final doc in _docs) {
      _pickedFiles[doc.type] = widget.initialDocuments[doc.type];
    }
  }

  List<_DocDescriptor> _buildDescriptors(AccountType accountType) {
    if (accountType == AccountType.charity) {
      return [
        _DocDescriptor(
          icon: Icons.verified_outlined,
          type: AppStrings.docTypeAssociationCertificate,
          title: AppStrings.associationCertLabel,
          subtitle: AppStrings.associationCertSubtitle,
        ),
        _DocDescriptor(
          icon: Icons.menu_book_outlined,
          type: AppStrings.docTypeCharityBylaws,
          title: AppStrings.charityBylawsLabel,
          subtitle: AppStrings.charityBylawsSubtitle,
        ),
        _DocDescriptor(
          icon: Icons.people_outline,
          type: AppStrings.docTypeBoardOfDirectorsList,
          title: AppStrings.boardOfDirectorsListLabel,
          subtitle: AppStrings.boardOfDirectorsListSubtitle,
        ),
      ];
    }

    // Default: Merchant / Seller
    return [
      _DocDescriptor(
        icon: Icons.business_outlined,
        type: AppStrings.docTypeCommercialRegistration,
        title: AppStrings.commercialRegLabel,
        subtitle: AppStrings.commercialRegSubtitle,
      ),
      _DocDescriptor(
        icon: Icons.receipt_long_outlined,
        type: AppStrings.docTypeTaxIdCertificate,
        title: AppStrings.taxIdLabel,
        subtitle: AppStrings.taxIdSubtitle,
      ),
      _DocDescriptor(
        icon: Icons.storefront_outlined,
        type: AppStrings.docTypeStoreFacilityPhoto,
        title: AppStrings.storeFacilityPhotoLabel,
        subtitle: AppStrings.storeFacilityPhotoSubtitle,
      ),
    ];
  }

  Future<void> _pickDocument(String type) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
      // withData: true forces file_picker to load bytes during the pick dialog.
      // This is essential for cloud sources (Google Drive, OneDrive, etc.) where
      // the content URI may not resolve to a readable path after the dialog closes.
      withData: true,
    );

    if (result == null) return;

    final platformFile = result.files.single;
    File? file;

    // 1. Prefer the native path if the file already exists on disk.
    if (platformFile.path != null) {
      final candidate = File(platformFile.path!);
      if (await candidate.exists()) {
        file = candidate;
      }
    }

    // 2. Fallback: write the in-memory bytes to a temp file.
    //    This covers Google Drive and other cloud providers where file_picker
    //    copies the file asynchronously but the path isn't ready yet.
    if (file == null && platformFile.bytes != null) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${platformFile.name}');
      await tempFile.writeAsBytes(platformFile.bytes!);
      file = tempFile;
    }

    if (file != null) {
      setState(() {
        _pickedFiles[type] = file;
      });
      widget.onDocumentsChanged(Map.unmodifiable(_pickedFiles));
    }
  }

  void _removeDocument(String type) {
    setState(() {
      _pickedFiles[type] = null;
    });
    widget.onDocumentsChanged(Map.unmodifiable(_pickedFiles));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: Icons.description_outlined,
          title: AppStrings.legalDocumentsSectionTitle,
        ),
        SizedBox(height: 16.h),
        ...List.generate(_docs.length, (i) {
          final doc = _docs[i];
          final pickedFile = _pickedFiles[doc.type];
          return Column(
            children: [
              DocumentTile(
                icon: doc.icon,
                title: doc.title,
                subtitle: doc.subtitle,
                pickedFileName:
                    pickedFile?.path.split(Platform.pathSeparator).last,
                onUpload: () => _pickDocument(doc.type),
                onRemove:
                    pickedFile != null ? () => _removeDocument(doc.type) : null,
              ),
              if (i < _docs.length - 1) SizedBox(height: 12.h),
            ],
          );
        }),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14.r,
                color: AppColors.neutral,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppStrings.verificationTimeNote,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocDescriptor {
  const _DocDescriptor({
    required this.icon,
    required this.type,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;

  /// The exact enum value sent to the backend as `Type`.
  final String type;

  /// The Arabic display label shown in the UI.
  final String title;

  final String subtitle;
}
