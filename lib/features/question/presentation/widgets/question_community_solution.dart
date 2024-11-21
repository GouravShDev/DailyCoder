import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/common/widgets/app_pagination_list.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/community_post_detail/community_post_detail_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/community_solutions/community_solutions_bloc.dart';
import 'package:codersgym/features/question/presentation/widgets/solution_post_tile.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class QuestionCommunitySolution extends HookWidget {
  const QuestionCommunitySolution({super.key, required this.question});
  final Question question;

  @override
  Widget build(BuildContext context) {
    final communitySolutionCubit = context.read<CommunitySolutionsBloc>();

    useEffect(
      () {
        communitySolutionCubit.add(FetchCommunitySolutionListEvent(
          questionTitleSlug: question.titleSlug ?? '',
        ));
        return null;
      },
      [],
    );
    return BlocBuilder<CommunitySolutionsBloc, CommunitySolutionsState>(
      builder: (context, state) {
        final solutions = state.solutions;
        if (state.isLoading && solutions.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return AppPaginationList(
          scrollController: InheritedDataProvider.of<ScrollController>(context),
          itemBuilder: (context, index) {
            return SolutionPostTile(
              postDetail: solutions[index],
              onCardTap: () {
                AutoRouter.of(context).push(
                  CommunityPostRoute(
                    postDetail: solutions[index],
                  ),
                );
              },
            );
          },
          itemCount: solutions.length,
          moreAvailable: state.moreSolutionsAvailable,
          loadMoreData: () {
            communitySolutionCubit.add(FetchCommunitySolutionListEvent(
              questionTitleSlug: question.titleSlug ?? '',
            ));
          },
        );
      },
    );
  }
}