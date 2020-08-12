json.monthly_amount Sellers::SettlementStatement.amount_sum(@settlement_statements)
json.processing_amount Sellers::SettlementStatement.amount_sum(@settlement_statements.requested)
json.paid_amount Sellers::SettlementStatement.amount_sum(@settlement_statements.accepted)
json.settlement_list @settlement_statements, partial: 'sellers/users/settlement_statements/settlement_statement', as: :settlement_statement
