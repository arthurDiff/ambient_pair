use crate::{models::Event, response::e500};
use actix_web::{HttpResponse, web};
use clerk_rs::validators::authorizer::ClerkJwt;
use sqlx::PgPool;
pub async fn get_event(
    path: web::Path<super::EventPath>,
    sess: web::ReqData<ClerkJwt>,
    pool: web::Data<PgPool>,
) -> Result<HttpResponse, actix_web::Error> {
    let Some(evt) = sqlx::query_as!(
        Event,
        r#"SELECT * 
        FROM event e 
        WHERE EXISTS ( SELECT 1 FROM member m WHERE m.user_id = $1 AND m.event_id = $2)"#,
        sess.sub,
        path.event_id
    )
    .fetch_optional(pool.as_ref())
    .await
    .map_err(e500)?
    else {
        return Ok(HttpResponse::NotFound().finish());
    };

    Ok(HttpResponse::Ok().json(evt))
}
