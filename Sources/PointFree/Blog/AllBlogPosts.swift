import Models

func allBlogPosts() -> [BlogPost] {
  let now = Current.date()
  return _allBlogPosts
    .filter {
      Current.envVars.appEnv == .production
        ? $0.publishedAt <= now
        : true
  }
}

private let _allBlogPosts: [BlogPost] = [
  post0001_welcome,
  post0002_episodeCredits,
  post0003_ep14Solutions,
  post0004_overtureSetters,
  post0005_stylingWithFunctions,
  post0006_taggedSecondsAndMilliseconds,
  post0007_openSourcingNonEmpty,
  post0008_conditionalCoding,
  post0009_6moAnniversary,
  post0010_studentDiscounts,
  post0011_solutionsToZipExercisesPt1,
  post0012_solutionsToZipExercisesPt2,
  post0013_solutionsToZipExercisesPt3,
  post0014_openSourcingValidated,
  post0015_overtureNowWithZip,
  post0016_announcingSwiftHtml,
  post0017_typeSafeVapor,
  post0018_typeSafeKitura,
  post0019_randomZalgoGenerator,
  post0020_PodcastRSS,
  post0021_howToControlTheWorld,
  post0022_someNewsAboutContramap,
  post0023_openSourcingSnapshotTesting,
  post0024_holidayDiscount,
  post0025_2018YearInReview,
  post0026_html020,
  post0027_openSourcingGen,
  post0028_openSourcingEnumProperties,
  post0029_enterpriseSubscriptions,
  post0030_SwiftUIAndStateManagementCorrections,
  post0031_HigherOrderSnapshotStrategies,
  post0032_AnOverviewOfCombine,
  post0033_CyberMondaySale,
  post0034_TestingSwiftUI,
  post0035_SnapshotTestingSwiftUI,
  post0036_HolidayDiscount,
  post0037_2019YearInReview,
  post0038_openSourcingCasePaths,
  post0039_Referrals,
  post0040_Collections,
  post0041_AnnouncingTheComposableArchitecture,
  post0042_RegionalDiscounts,
  post0043_AnnouncingComposableCoreLocation,
  post0044,
  post0045_OpenSourcingCombinePublishers,
  post0046_AnnouncingComposableCoreMotion,
  post0047_ComposableAlerts,
  post0048_CyberMondaySale,
  post0049_OpenSourcingParsing,
  post0050_EOY2020,
  post0051_2020EOYSale,
  post0052,
  post0053_composableArchitectureTestStoreErgonomics,
  post0054_AnnouncingIsowords,
  post0055_OpenSourcingIsowords,
  post0056_BetterTestingBonanza,
  post0057_tourOfIsowords,
  post0058_WWDCSale,
  post0059_SwitchStore,
  post0060_OpenSourcingIdentifiedCollections,
  post0061_BetterPerformanceBonanza,
  post0062_AnnouncingCustomDump,
  post0063_SaferConciserForms,
  post0064_AppleEvent,
]
